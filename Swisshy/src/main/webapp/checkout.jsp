<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.Cart, com.tap.model.CartItem, java.util.List" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.html"); return;
    }
    Cart cart = (Cart) s.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("restaurant"); return;
    }
    String userName = (String) s.getAttribute("userName");
    double total = cart.getTotal() * 1.05;
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ForkDash — Checkout</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    :root{--bg:#080808;--surface:#0f0f0f;--card:#161616;--border:#222;--accent:#ff5c2b;--text:#f0ede8;--muted:#666;--nav-h:72px}
    body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}
    nav{position:fixed;top:0;left:0;right:0;z-index:100;height:var(--nav-h);display:flex;align-items:center;justify-content:space-between;padding:0 40px;background:rgba(8,8,8,.92);backdrop-filter:blur(20px);border-bottom:1px solid rgba(255,255,255,.05)}
    .logo{font-family:'Syne',sans-serif;font-weight:800;font-size:1.5rem;color:var(--text);text-decoration:none}
    .logo span{color:var(--accent)}
    .nav-r{display:flex;gap:8px}
    .nl{padding:7px 16px;border-radius:50px;color:var(--muted);text-decoration:none;font-size:.84rem;font-weight:500;transition:all .2s}
    .nl:hover{background:rgba(255,255,255,.06);color:var(--text)}

    .page{max-width:960px;margin:0 auto;padding:calc(var(--nav-h)+50px) 40px 80px;display:grid;grid-template-columns:1fr 340px;gap:28px;align-items:start}
    .eye{font-size:.71rem;font-weight:600;letter-spacing:2.5px;text-transform:uppercase;color:var(--accent);margin-bottom:10px}
    .ptitle{font-family:'Syne',sans-serif;font-weight:800;font-size:2rem;letter-spacing:-1px;margin-bottom:32px}

    .card{background:var(--card);border:1px solid var(--border);border-radius:20px;padding:28px;margin-bottom:20px}
    .card-title{font-family:'Syne',sans-serif;font-weight:700;font-size:1rem;margin-bottom:20px;color:var(--text)}

    label{display:block;font-size:.8rem;font-weight:600;color:var(--muted);margin-bottom:6px;text-transform:uppercase;letter-spacing:1px}
    input,textarea{width:100%;background:var(--surface);border:1px solid var(--border);border-radius:10px;padding:12px 14px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.9rem;outline:none;transition:border-color .2s;margin-bottom:16px}
    input:focus,textarea:focus{border-color:var(--accent)}
    textarea{resize:vertical;min-height:80px}

    .order-row{display:flex;justify-content:space-between;font-size:.87rem;margin-bottom:10px}
    .order-row .lbl{color:var(--muted)}
    hr{border:none;border-top:1px solid var(--border);margin:14px 0}
    .order-total{display:flex;justify-content:space-between;font-family:'Syne',sans-serif;font-weight:800;font-size:1.1rem}
    .order-total span:last-child{color:var(--accent)}

    .place-btn{display:block;width:100%;margin-top:20px;padding:15px;background:var(--accent);color:#fff;border:none;border-radius:14px;font-family:'Syne',sans-serif;font-size:1rem;font-weight:700;cursor:pointer;text-align:center;transition:all .2s;box-shadow:0 6px 24px rgba(255,92,43,.3)}
    .place-btn:hover{background:#e04d22;transform:translateY(-2px)}
    .back-link{display:inline-flex;align-items:center;gap:6px;color:var(--muted);text-decoration:none;font-size:.85rem;margin-bottom:24px;transition:color .2s}
    .back-link:hover{color:var(--accent)}
    .error-box{background:rgba(255,77,77,.1);border:1px solid rgba(255,77,77,.3);color:#ff6b6b;border-radius:12px;padding:14px 18px;margin-bottom:20px;font-size:.88rem}
    .item-chip{display:flex;justify-content:space-between;font-size:.83rem;padding:8px 0;border-bottom:1px solid var(--border)}
    .item-chip:last-child{border-bottom:none}

    @media(max-width:768px){.page{grid-template-columns:1fr;padding:calc(var(--nav-h)+28px) 16px 60px}nav{padding:0 18px}}
  </style>
</head>
<body>
<nav>
  <a class="logo" href="index.jsp">Fork<span>Dash</span></a>
  <div class="nav-r">
    <a href="restaurant" class="nl">Restaurants</a>
    <a href="cart" class="nl">🛒 Cart (<%= cart.getItemCount() %>)</a>
    <a href="logout" class="nl" style="color:#ff5555">Logout</a>
  </div>
</nav>

<div class="page">

  <!-- LEFT: DELIVERY DETAILS FORM -->
  <div>
    <a href="cart" class="back-link">← Back to Cart</a>
    <div class="eye">Final Step</div>
    <h1 class="ptitle">Checkout</h1>

    <% if (error != null) { %>
    <div class="error-box">⚠️ <%= error %></div>
    <% } %>

    <form method="post" action="checkout">
      <div class="card">
        <div class="card-title">📍 Delivery Details</div>

        <label>Full Name</label>
        <input type="text" name="name" value="<%= userName != null ? userName : "" %>" required/>

        <label>Phone Number</label>
        <input type="tel" name="phone" placeholder="Enter your phone number" required/>

        <label>Delivery Address</label>
        <textarea name="address" placeholder="Enter your full delivery address..." required></textarea>
      </div>

      <div class="card">
        <div class="card-title">💳 Payment Method</div>
        <div style="display:flex;flex-direction:column;gap:10px">
          <label style="display:flex;align-items:center;gap:10px;cursor:pointer;text-transform:none;letter-spacing:0;font-size:.9rem;color:var(--text)">
            <input type="radio" name="payment" value="cod" checked style="width:auto;margin:0"/> Cash on Delivery
          </label>
          <label style="display:flex;align-items:center;gap:10px;cursor:pointer;text-transform:none;letter-spacing:0;font-size:.9rem;color:var(--muted)">
            <input type="radio" name="payment" value="online" disabled style="width:auto;margin:0"/> Online Payment (coming soon)
          </label>
        </div>
      </div>

      <button type="submit" class="place-btn">🍽️ Place Order — ₹<%= String.format("%.0f", total) %></button>
    </form>
  </div>

  <!-- RIGHT: ORDER SUMMARY -->
  <div class="card" style="position:sticky;top:calc(var(--nav-h)+20px)">
    <div class="card-title">🧾 Order Summary</div>

    <% for (CartItem item : cart.getItems()) { %>
    <div class="item-chip">
      <span><%= item.getItemName() %> × <%= item.getQuantity() %></span>
      <span>₹<%= String.format("%.0f", item.getSubtotal()) %></span>
    </div>
    <% } %>

    <hr/>
    <div class="order-row"><span class="lbl">Subtotal</span><span>₹<%= String.format("%.0f", cart.getTotal()) %></span></div>
    <div class="order-row"><span class="lbl">Delivery</span><span style="color:#22c55e">FREE</span></div>
    <div class="order-row"><span class="lbl">Taxes (5%)</span><span>₹<%= String.format("%.0f", cart.getTotal() * 0.05) %></span></div>
    <hr/>
    <div class="order-total"><span>Total</span><span>₹<%= String.format("%.0f", total) %></span></div>
  </div>

</div>
</body>
</html>
