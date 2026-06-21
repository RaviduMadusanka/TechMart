
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart - Register</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }
        .register-card {
            background: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px;
        }
        .register-card h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-weight: 700;
        }
        .row {
            display: flex;
            gap: 15px;
        }
        .row .form-group {
            flex: 1;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        .form-group input:focus {
            border-color: #11998e;
            outline: none;
            box-shadow: 0 0 5px rgba(17, 153, 142, 0.5);
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background-color: #11998e;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-submit:hover {
            background-color: #0e8074;
        }
        .message.error {
            color: #d8000c;
            background-color: #ffbaba;
            padding: 10px;
            border-radius: 6px;
            text-align: center;
            margin-bottom: 20px;
        }
        .footer-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        .footer-link a {
            color: #11998e;
            text-decoration: none;
            font-weight: bold;
        }
        .footer-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="register-card">
    <h2>Create an Account</h2>

    <% if(request.getAttribute("errorMessage") != null) { %>
    <div class="message error">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <form method="POST" action="auth?action=register">
        <div class="row">
            <div class="form-group">
                <label>First Name</label>
                <input type="text" name="firstName" placeholder="John" required>
            </div>
            <div class="form-group">
                <label>Last Name</label>
                <input type="text" name="lastName" placeholder="Doe">
            </div>
        </div>

        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="johndoe@example.com" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Create a strong password" required>
        </div>

        <button type="submit" class="btn-submit">Register</button>
    </form>

    <div class="footer-link">
        Already have an account? <a href="auth?action=login">Login Here</a>
    </div>
</div>

</body>
</html>