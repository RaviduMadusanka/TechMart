<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("loggedUserEmail") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart - Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            display: flex;
            height: 100vh;
        }
        .sidebar {
            width: 250px;
            background-color: #343a40;
            color: #fff;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }
        .sidebar-header {
            padding: 20px;
            text-align: center;
            background-color: #23272b;
            font-size: 24px;
            font-weight: bold;
            color: #17a2b8;
            letter-spacing: 1px;
        }
        .nav-links {
            list-style: none;
            padding: 0;
            margin: 0;
            flex: 1;
        }
        .nav-links li a {
            display: block;
            padding: 15px 20px;
            color: #c2c7d0;
            text-decoration: none;
            font-size: 16px;
            border-bottom: 1px solid #454d55;
            transition: all 0.3s;
        }
        .nav-links li a:hover, .nav-links li a.active {
            background-color: #17a2b8;
            color: white;
            padding-left: 25px;
        }


        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #fff;
            padding: 15px 25px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .welcome-card {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border-left: 5px solid #17a2b8;
        }
        .welcome-card h2 {
            margin-top: 0;
            color: #333;
        }
        .info-text {
            font-size: 18px;
            color: #555;
        }
        .action-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 25px;
            background: #17a2b8;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background 0.3s;
        }
        .action-btn:hover {
            background: #138496;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-header">
        TechMart
    </div>
    <ul class="nav-links">
        <li><a href="#" class="active">Dashboard</a></li>
        <li><a href="test-cart">Products</a></li>
        <li><a href="#">Inventory</a></li>
        <li><a href="#">Orders</a></li>
        <li><a href="#">Shopping Cart</a></li>
        <li><a href="#">Notifications</a></li>
        <li><a href="#">Performance Metrics</a></li>
        <li style="margin-top: auto;"><a href="auth?action=logout" style="background-color: #dc3545; text-align: center;">Logout</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="top-bar">
        <h3 style="margin: 0; color: #333;">Dashboard Overview</h3>
        <span style="color: #666;">Logged in as: <b><%= session.getAttribute("loggedUserName") %></b></span>
    </div>

    <div class="welcome-card">
        <h2>Welcome to TechMart! 🎉</h2>
        <p class="info-text"><b>Name:</b> <%= session.getAttribute("loggedUserName") %></p>
        <p class="info-text"><b>Email:</b> <%= session.getAttribute("loggedUserEmail") %></p>

        <a href="test-cart" class="action-btn">Go to Store ➔</a>
    </div>
</div>

</body>
</html>