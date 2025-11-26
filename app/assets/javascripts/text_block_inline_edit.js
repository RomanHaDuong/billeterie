function initEditMode() {
  // Handle edit mode toggle button
  var toggleBtn = document.getElementById('cms-edit-toggle');
  if (toggleBtn) {
    // Remove old listener
    var newToggleBtn = toggleBtn.cloneNode(true);
    toggleBtn.parentNode.replaceChild(newToggleBtn, toggleBtn);
    
    newToggleBtn.addEventListener('click', function() {
      fetch('/toggle_edit_mode', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      }).then(function(response) {
        return response.json();
      }).then(function(data) {
        var icon = newToggleBtn.querySelector('i');
        var text = newToggleBtn.querySelector('span');
        
        if (data.edit_mode) {
          newToggleBtn.classList.add('btn-warning');
          newToggleBtn.classList.remove('btn-outline-primary');
          icon.className = 'fa fa-check';
          text.textContent = 'Édition activée';
          
          // Show all editable blocks with better styling
          document.querySelectorAll('[data-editable-text-block]').forEach(function(el) {
            el.classList.add('cms-editable-active');
          });
          
          // Show helper message
          showEditModeHelper();
        } else {
          newToggleBtn.classList.remove('btn-warning');
          newToggleBtn.classList.add('btn-outline-primary');
          icon.className = 'fa fa-edit';
          text.textContent = 'Éditer le site';
          
          // Hide editable block styles
          document.querySelectorAll('[data-editable-text-block]').forEach(function(el) {
            el.classList.remove('cms-editable-active');
          });
          
          // Remove helper message
          removeEditModeHelper();
        }
      });
    });
  }
  
  // Show helper message when entering edit mode
  function showEditModeHelper() {
    removeEditModeHelper(); // Remove any existing helper
    
    var helper = document.createElement('div');
    helper.id = 'cms-edit-helper';
    helper.className = 'alert alert-info alert-dismissible fade show';
    helper.style.cssText = 'position: fixed; top: 80px; right: 20px; z-index: 9999; max-width: 350px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);';
    helper.innerHTML = `
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <strong><i class="fa fa-info-circle me-2"></i>Mode édition activé</strong>
      <p class="mb-0 mt-2 small">Cliquez sur n'importe quel texte surligné pour le modifier. Appuyez sur Entrée pour sauvegarder.</p>
    `;
    document.body.appendChild(helper);
    
    // Auto-hide after 5 seconds
    setTimeout(function() {
      if (helper && helper.parentNode) {
        helper.classList.remove('show');
        setTimeout(function() {
          removeEditModeHelper();
        }, 150);
      }
    }, 5000);
  }
  
  function removeEditModeHelper() {
    var helper = document.getElementById('cms-edit-helper');
    if (helper) {
      helper.remove();
    }
  }

  // Handle inline editing of text blocks
  function setupEditableBlocks() {
    document.querySelectorAll('[data-editable-text-block]').forEach(function(el) {
      // Remove old listeners by cloning
      var newEl = el.cloneNode(true);
      el.parentNode.replaceChild(newEl, el);
      
      newEl.addEventListener('click', function(e) {
        // Only allow editing if element has the active class
        if (!newEl.classList.contains('cms-editable-active')) return;
        
        e.preventDefault();
        e.stopPropagation();
        if (newEl.querySelector('input') || newEl.querySelector('textarea')) return;
        
        var id = newEl.dataset.textBlockId;
        var content = newEl.textContent.trim();
        var isMultiline = content.length > 80 || content.includes('\n');
        
        // Store original styles
        var computedStyle = window.getComputedStyle(newEl);
        var originalFontSize = computedStyle.fontSize;
        var originalFontWeight = computedStyle.fontWeight;
        var originalFontFamily = computedStyle.fontFamily;
        var originalLineHeight = computedStyle.lineHeight;
        var originalColor = computedStyle.color;
        var originalWidth = newEl.offsetWidth;
        
        var input;
        if (isMultiline) {
          input = document.createElement('textarea');
          input.rows = 3;
        } else {
          input = document.createElement('input');
          input.type = 'text';
        }
        
        input.value = content;
        input.style.fontSize = originalFontSize;
        input.style.fontWeight = originalFontWeight;
        input.style.fontFamily = originalFontFamily;
        input.style.lineHeight = originalLineHeight;
        input.style.color = originalColor;
        input.style.width = '100%';
        input.style.minWidth = originalWidth + 'px';
        input.style.border = '2px solid #0d6efd';
        input.style.borderRadius = '6px';
        input.style.padding = '8px 12px';
        input.style.background = '#fff';
        input.style.boxSizing = 'border-box';
        input.style.margin = '0';
        input.style.boxShadow = '0 4px 12px rgba(13, 110, 253, 0.2)';
        input.style.outline = 'none';
        
        // Add save/cancel buttons
        var btnGroup = document.createElement('div');
        btnGroup.style.cssText = 'margin-top: 8px; display: flex; gap: 8px;';
        
        var saveBtn = document.createElement('button');
        saveBtn.className = 'btn btn-sm btn-primary';
        saveBtn.innerHTML = '<i class="fa fa-check me-1"></i>Enregistrer';
        saveBtn.type = 'button';
        
        var cancelBtn = document.createElement('button');
        cancelBtn.className = 'btn btn-sm btn-outline-secondary';
        cancelBtn.innerHTML = '<i class="fa fa-times me-1"></i>Annuler';
        cancelBtn.type = 'button';
        
        btnGroup.appendChild(saveBtn);
        btnGroup.appendChild(cancelBtn);
        
        newEl.innerHTML = '';
        newEl.appendChild(input);
        newEl.appendChild(btnGroup);
        input.focus();
        input.select();
        
        var saveEdit = function() {
          var newContent = input.value;
          saveBtn.disabled = true;
          saveBtn.innerHTML = '<i class="fa fa-spinner fa-spin me-1"></i>Sauvegarde...';
          
          fetch('/text_blocks/' + id, {
            method: 'PATCH',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({ text_block: { content: newContent } })
          }).then(function(response) {
            return response.json();
          }).then(function(data) {
            if (data.success) {
              newEl.textContent = data.content;
              newEl.style.background = 'rgba(25, 135, 84, 0.2)';
              setTimeout(function() {
                newEl.style.background = '';
              }, 1000);
            } else {
              alert('Erreur: ' + (data.errors || 'Erreur inconnue'));
              newEl.textContent = content;
            }
          }).catch(function(error) {
            console.error('Error:', error);
            alert('Erreur lors de la sauvegarde');
            newEl.textContent = content;
          });
        };
        
        var cancelEdit = function() {
          newEl.textContent = content;
        };
        
        saveBtn.addEventListener('click', saveEdit);
        cancelBtn.addEventListener('click', cancelEdit);
        
        input.addEventListener('keydown', function(e) {
          if (e.key === 'Enter' && !e.shiftKey && !isMultiline) {
            e.preventDefault();
            saveEdit();
          } else if (e.key === 'Escape') {
            cancelEdit();
          }
        });
      });
    });
  }
  
  setupEditableBlocks();
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', initEditMode);

// Re-initialize on Turbo navigation
document.addEventListener('turbo:load', initEditMode);
document.addEventListener('turbo:render', initEditMode);
