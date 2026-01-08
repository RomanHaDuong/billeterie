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
        if (data.edit_mode) {
          newToggleBtn.classList.add('active', 'btn-warning');
          newToggleBtn.classList.remove('btn-outline-secondary');
          // Show all editable blocks
          document.querySelectorAll('[data-editable-text-block]').forEach(function(el) {
            el.style.cursor = 'pointer';
            el.style.borderBottom = '2px dashed #ffc107';
            el.style.padding = '2px 4px';
            el.style.display = 'inline-block';
          });
        } else {
          newToggleBtn.classList.remove('active', 'btn-warning');
          newToggleBtn.classList.add('btn-outline-secondary');
          // Hide editable block styles
          document.querySelectorAll('[data-editable-text-block]').forEach(function(el) {
            el.style.cursor = '';
            el.style.borderBottom = '';
            el.style.padding = '';
            el.style.display = '';
          });
        }
      });
    });
  }

  // Handle inline editing of text blocks
  function setupEditableBlocks() {
    document.querySelectorAll('[data-editable-text-block]').forEach(function(el) {
      // Remove old listeners by cloning
      var newEl = el.cloneNode(true);
      el.parentNode.replaceChild(newEl, el);
      
      newEl.addEventListener('click', function(e) {
        // Only allow editing if the element has cursor:pointer style (edit mode is on)
        var computedCursor = window.getComputedStyle(newEl).cursor;
        if (computedCursor !== 'pointer') return;
        
        e.preventDefault();
        if (newEl.querySelector('input') || newEl.querySelector('textarea')) return;
        
        var id = newEl.dataset.textBlockId;
        var content = newEl.textContent.trim();
        var isMultiline = content.length > 50 || content.includes('\n');
        
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
        input.style.width = originalWidth + 'px';
        input.style.minWidth = originalWidth + 'px';
        input.style.border = '2px solid #ffc107';
        input.style.borderRadius = '4px';
        input.style.padding = computedStyle.padding;
        input.style.background = 'rgba(255, 193, 7, 0.1)';
        input.style.boxSizing = 'border-box';
        input.style.margin = '0';
        
        newEl.innerHTML = '';
        newEl.appendChild(input);
        input.focus();
        input.select();
        
        var saveEdit = function() {
          var newContent = input.value;
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
            } else {
              alert('Error saving: ' + (data.errors || 'Unknown error'));
              newEl.textContent = content;
            }
          }).catch(function(error) {
            console.error('Error:', error);
            newEl.textContent = content;
          });
        };
        
        input.addEventListener('blur', saveEdit);
        input.addEventListener('keydown', function(e) {
          if (e.key === 'Enter' && !e.shiftKey && !isMultiline) {
            e.preventDefault();
            saveEdit();
          } else if (e.key === 'Escape') {
            newEl.textContent = content;
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
