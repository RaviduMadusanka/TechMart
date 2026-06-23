function togglePassword(fieldId, btn) {
    const field = document.getElementById(fieldId);
    field.type = field.type === 'password' ? 'text' : 'password';
}

document.getElementById('adminLoginForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const btn = document.getElementById('submitBtn');
    const originalBtnContent = btn.innerHTML;
    const messageContainer = document.getElementById('ajaxMessageContainer');

    btn.innerHTML = `
                <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                <span>Authenticating...</span>
            `;
    btn.disabled = true;
    btn.classList.add('opacity-75', 'cursor-not-allowed');

    const formData = new FormData(this);

    fetch('admin-auth', {
        method: 'POST',
        body: new URLSearchParams(formData)
    })
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');

            const errorSpan = doc.querySelector('.text-red-400') || doc.querySelector('.message.error');

            if (errorSpan) {
                const errorMsg = errorSpan.innerText || "Invalid Credentials!";
                messageContainer.innerHTML = `
                        <div class="bg-red-500/10 border border-red-500/30 rounded-lg p-3 mb-5 flex items-center gap-2 slide-up">
                            <svg class="w-4 h-4 text-red-400 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"/>
                            </svg>
                            <span class="text-red-400 text-sm font-medium">` + errorMsg + `</span>
                        </div>
                    `;

                btn.innerHTML = originalBtnContent;
                btn.disabled = false;
                btn.classList.remove('opacity-75', 'cursor-not-allowed');
            } else {
                messageContainer.innerHTML = `
                        <div class="bg-green-500/10 border border-green-500/30 rounded-lg p-3 mb-5 flex items-center gap-2 slide-up">
                            <svg class="w-4 h-4 text-green-400 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"/>
                            </svg>
                            <span class="text-green-400 text-sm font-medium">Access Granted! Redirecting to Dashboard...</span>
                        </div>
                    `;

                setTimeout(() => {
                    window.location.href = "dashboard.jsp";
                }, 1000);
            }
        })
        .catch(error => {
            messageContainer.innerHTML = `
                    <div class="bg-red-500/10 border border-red-500/30 rounded-lg p-3 mb-5 flex items-center gap-2 slide-up">
                        <span class="text-red-400 text-sm font-medium">Network error! Please try again.</span>
                    </div>
                `;
            btn.innerHTML = originalBtnContent;
            btn.disabled = false;
            btn.classList.remove('opacity-75', 'cursor-not-allowed');
        });
});