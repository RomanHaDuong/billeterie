document.addEventListener('DOMContentLoaded', function() {
  var toggleBtn = document.getElementById('cms-edit-toggle');
  if (!toggleBtn) return;
  toggleBtn.addEventListener('click', function() {
    window.isAdminEditMode = !window.isAdminEditMode;
    document.body.classList.toggle('cms-edit-mode', window.isAdminEditMode);
    document.querySelectorAll('[data-editable-text-block]').forEach(function(el) {
      el.classList.toggle('cms-editable', window.isAdminEditMode);
    });
  });
});
