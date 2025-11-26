document.addEventListener('DOMContentLoaded', function() {
  // Handle edit mode toggle button
  var toggleBtn = document.getElementById('cms-edit-toggle');
  if (toggleBtn) {
    toggleBtn.addEventListener('click', function() {
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
          toggleBtn.classList.add('active', 'btn-warning');
          toggleBtn.classList.remove('btn-outline-secondary');
        } else {
          toggleBtn.classList.remove('active', 'btn-warning');
          toggleBtn.classList.add('btn-outline-secondary');
        }
        location.reload();
      });
    });
  }

  // Handle inline editing of text blocks
  document.querySelectorAll('[data-editable-text-block]').forEach(function(el) {
    el.addEventListener('click', function(e) {
      e.preventDefault();
      if (el.querySelector('input') || el.querySelector('textarea')) return;
      
      var id = el.dataset.textBlockId;
      var content = el.textContent.trim();
      var isMultiline = content.length > 50 || content.includes('\n');
      
      var input;
      if (isMultiline) {
        input = document.createElement('textarea');
        input.rows = 3;
      } else {
        input = document.createElement('input');
        input.type = 'text';
      }
      
      input.value = content;
      input.className = 'form-control form-control-sm';
      input.style.width = '100%';
      input.style.minWidth = '200px';
      
      el.innerHTML = '';
      el.appendChild(input);
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
            el.textContent = data.content;
          } else {
            alert('Error saving: ' + (data.errors || 'Unknown error'));
            el.textContent = content;
          }
        }).catch(function(error) {
          console.error('Error:', error);
          el.textContent = content;
        });
      };
      
      input.addEventListener('blur', saveEdit);
      input.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !e.shiftKey && !isMultiline) {
          e.preventDefault();
          saveEdit();
        } else if (e.key === 'Escape') {
          el.textContent = content;
        }
      });
    });
  });
});
