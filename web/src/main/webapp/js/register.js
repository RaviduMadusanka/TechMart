function togglePassword(id) {
    const f = document.getElementById(id);
    f.type = f.type === 'password' ? 'text' : 'password';
}

document.getElementById('password').addEventListener('input', function() {
    const val = this.value;
    let strength = 0;
    if (val.length >= 8) strength++;
    if (/[A-Z]/.test(val)) strength++;
    if (/[0-9]/.test(val)) strength++;
    if (/[^A-Za-z0-9]/.test(val)) strength++;

    const colors = ['bg-red-400', 'bg-orange-400', 'bg-yellow-400', 'bg-green-500'];
    const labels = ['Weak', 'Fair', 'Good', 'Strong'];
    for (let i = 1; i <= 4; i++) {
        const bar = document.getElementById('bar' + i);
        bar.className = 'h-1 flex-1 rounded ' + (i <= strength ? colors[strength-1] : 'bg-slate-200');
    }
    document.getElementById('strengthText').textContent = val.length === 0 ? 'Enter password to check strength' : labels[strength-1] + ' password';
});

document.getElementById('registerForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const btn = document.getElementById('submitBtn');
    const originalBtnContent = btn.innerHTML;
    const messageContainer = document.getElementById('ajaxMessageContainer');

    btn.innerHTML = `
            <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            <span>Processing...</span>
        `;
    btn.disabled = true;
    btn.classList.add('opacity-75', 'cursor-not-allowed');

    const formData = new FormData(this);

    fetch('auth?action=register', {
        method: 'POST',
        body: new URLSearchParams(formData)
    })
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');

            if (doc.title.includes("Sign In") || doc.title.includes("Login")) {
                messageContainer.innerHTML = `
                    <div class="bg-green-50 border border-green-200 rounded-lg p-3 mb-6 flex items-center gap-2 fade-slide">
                        <svg class="w-4 h-4 text-green-500 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"/>
                        </svg>
                        <span class="text-green-700 text-sm font-medium">Registration Successful! Redirecting to login...</span>
                    </div>
                `;
                setTimeout(() => {
                    window.location.href = "auth?action=login";
                }, 2000);
            } else {
                const errorSpan = doc.querySelector('.text-red-600');
                const errorMsg = errorSpan ? errorSpan.innerText : "Registration failed. Email might already exist.";

                messageContainer.innerHTML = `
                    <div class="bg-red-50 border border-red-200 rounded-lg p-3 mb-6 flex items-center gap-2 fade-slide">
                        <svg class="w-4 h-4 text-red-500 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"/>
                        </svg>
                        <span class="text-red-600 text-sm font-medium">` + errorMsg + `</span>
                    </div>
                `;

                btn.innerHTML = originalBtnContent;
                btn.disabled = false;
                btn.classList.remove('opacity-75', 'cursor-not-allowed');
            }
        })
        .catch(error => {
            messageContainer.innerHTML = `
                <div class="bg-red-50 border border-red-200 rounded-lg p-3 mb-6 flex items-center gap-2 fade-slide">
                    <span class="text-red-600 text-sm font-medium">Network error occurred! Please try again.</span>
                </div>
            `;
            btn.innerHTML = originalBtnContent;
            btn.disabled = false;
            btn.classList.remove('opacity-75', 'cursor-not-allowed');
        });
});