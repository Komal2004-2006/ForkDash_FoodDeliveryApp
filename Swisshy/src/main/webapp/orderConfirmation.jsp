<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.html"); return;
    }
    Integer orderId = (Integer) s.getAttribute("lastOrderId");
    String orderTotal = (String) s.getAttribute("lastOrderTotal");
    String userName = (String) s.getAttribute("userName");
    if (orderId == null) {
        response.sendRedirect("restaurant"); return;
    }
    // Clear confirmation data from session
    s.removeAttribute("lastOrderId");
    s.removeAttribute("lastOrderTotal");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ForkDash — Order Confirmed!</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    :root{--bg:#080808;--card:#161616;--border:#222;--accent:#ff5c2b;--text:#f0ede8;--muted:#666;--nav-h:72px}
    body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center}
    nav{position:fixed;top:0;left:0;right:0;height:var(--nav-h);display:flex;align-items:center;justify-content:space-between;padding:0 40px;background:rgba(8,8,8,.92);backdrop-filter:blur(20px);border-bottom:1px solid rgba(255,255,255,.05)}
    .logo{font-family:'Syne',sans-serif;font-weight:800;font-size:1.5rem;color:var(--text);text-decoration:none}
    .logo span{color:var(--accent)}

    .box{text-align:center;max-width:500px;padding:20px}
    .tick{font-size:5rem;margin-bottom:24px;animation:pop .5s ease}
    @keyframes pop{from{transform:scale(0)}to{transform:scale(1)}}
    .title{font-family:'Syne',sans-serif;font-weight:800;font-size:2.2rem;margin-bottom:12px}
    .sub{color:var(--muted);font-size:1rem;line-height:1.6;margin-bottom:32px}
    .order-id{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:16px 24px;display:inline-block;margin-bottom:32px}
    .order-id span{font-family:'Syne',sans-serif;font-weight:800;font-size:1.3rem;color:var(--accent)}
    .order-id p{font-size:.8rem;color:var(--muted);margin-top:4px}
    .btns{display:flex;gap:12px;justify-content:center;flex-wrap:wrap}
    .btn{padding:13px 28px;border-radius:50px;font-family:'Syne',sans-serif;font-weight:700;font-size:.9rem;text-decoration:none;transition:all .2s}
    .btn-primary{background:var(--accent);color:#fff;box-shadow:0 6px 20px rgba(255,92,43,.3)}
    .btn-primary:hover{background:#e04d22;transform:translateY(-2px)}
    .btn-outline{border:1px solid var(--border);color:var(--muted)}
    .btn-outline:hover{border-color:var(--accent);color:var(--accent)}
    .eta{background:rgba(34,197,94,.1);border:1px solid rgba(34,197,94,.2);color:#22c55e;border-radius:50px;padding:8px 20px;font-size:.85rem;font-weight:600;display:inline-block;margin-bottom:28px}
  </style>
</head>
<body>
<nav>
  <a class="logo" href="index.jsp">Fork<span>Dash</span></a>
</nav>

<div class="box">
  <div class="tick">✅</div>
  <h1 class="title">Order Placed!</h1>
  <p class="sub">Hey <%= userName %>! Your order has been placed successfully and is being prepared.</p>

  <div class="eta">🕐 Estimated delivery: 30–45 minutes</div>

  <div class="order-id">
    <span>#<%= orderId %></span>
    <p>Order ID • Total: ₹<%= orderTotal %></p>
  </div>

  <div class="btns">
    <a href="restaurant" class="btn btn-primary">Order More Food</a>
    <a href="index.jsp" class="btn btn-outline">Back to Home</a>
  </div>
</div>
</body>
</html>
