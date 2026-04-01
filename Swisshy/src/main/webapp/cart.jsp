<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.Cart, com.tap.model.CartItem, java.util.List" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.html");
        return;
    }
    String userName = (String) s.getAttribute("userName");
    Cart cart = (Cart) s.getAttribute("cart");
    if (cart == null) {
        cart = new Cart();
        s.setAttribute("cart", cart);
    }
    List<CartItem> items = cart.getItems();
    double total = cart.getTotal();
    int count = cart.getItemCount();
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ForkDash — My Cart</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    :root{--bg:#080808;--surface:#0f0f0f;--card:#161616;--border:#222;--accent:#ff5c2b;--text:#f0ede8;--muted:#666;--nav-h:72px}
    body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

    /* NAV */
    nav{position:fixed;top:0;left:0;right:0;z-index:100;height:var(--nav-h);display:flex;align-items:center;justify-content:space-between;padding:0 40px;background:rgba(8,8,8,.92);backdrop-filter:blur(20px);border-bottom:1px solid rgba(255,255,255,.05)}
    .logo{font-family:'Syne',sans-serif;font-weight:800;font-size:1.5rem;color:var(--text);text-decoration:none}
    .logo span{color:var(--accent)}
    .nav-r{display:flex;align-items:center;gap:8px}
    .nl{display:flex;align-items:center;gap:5px;padding:7px 16px;border-radius:50px;color:var(--muted);text-decoration:none;font-size:.84rem;font-weight:500;transition:all .2s}
    .nl:hover{background:rgba(255,255,255,.06);color:var(--text)}
    .nl.on{color:var(--accent)}
    .cart-badge{background:var(--accent);color:#fff;border-radius:50%;width:18px;height:18px;font-size:.65rem;font-weight:800;display:inline-flex;align-items:center;justify-content:center;margin-left:2px}

    /* LAYOUT */
    .page{max-width:1000px;margin:0 auto;padding:calc(var(--nav-h)+50px) 40px 80px;display:grid;grid-template-columns:1fr 340px;gap:28px;align-items:start}
    .eye{font-size:.71rem;font-weight:600;letter-spacing:2.5px;text-transform:uppercase;color:var(--accent);margin-bottom:10px}
    .ptitle{font-family:'Syne',sans-serif;font-weight:800;font-size:2.2rem;letter-spacing:-1px;margin-bottom:32px}

    /* EMPTY STATE */
    .empty{grid-column:1/-1;text-align:center;padding:80px 20px}
    .empty-ico{font-size:4rem;margin-bottom:20px;opacity:.4}
    .empty h2{font-family:'Syne',sans-serif;font-size:1.5rem;margin-bottom:10px}
    .empty p{color:var(--muted);font-size:.93rem;margin-bottom:32px}
    .btn-primary{background:var(--accent);color:#fff;text-decoration:none;padding:13px 30px;border-radius:50px;font-family:'Syne',sans-serif;font-weight:700;font-size:.9rem;display:inline-flex;align-items:center;gap:8px;transition:all .2s}
    .btn-primary:hover{background:#e04d22;transform:translateY(-2px)}

    /* CART ITEMS */
    .cart-items{display:flex;flex-direction:column;gap:14px}
    .cart-item{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:18px 20px;display:flex;align-items:center;gap:16px;transition:border-color .2s;animation:fadeUp .4s ease both}
    .cart-item:hover{border-color:rgba(255,92,43,.2)}
    @keyframes fadeUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
    .item-ico{width:48px;height:48px;background:rgba(255,92,43,.1);border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;flex-shrink:0}
    .item-info{flex:1}
    .item-name{font-family:'Syne',sans-serif;font-weight:700;font-size:.95rem;margin-bottom:3px}
    .item-rest{font-size:.76rem;color:var(--muted)}
    .item-price{font-family:'Syne',sans-serif;font-weight:700;color:var(--accent);font-size:1rem;white-space:nowrap}
    .qty-ctrl{display:flex;align-items:center;gap:8px}
    .qty-btn{width:30px;height:30px;border-radius:8px;border:1px solid var(--border);background:var(--surface);color:var(--text);font-size:1rem;font-weight:700;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .15s}
    .qty-btn:hover{border-color:var(--accent);color:var(--accent)}
    .qty-num{font-family:'Syne',sans-serif;font-weight:700;font-size:.95rem;min-width:20px;text-align:center}
    .remove-btn{background:rgba(255,77,77,.1);border:1px solid rgba(255,77,77,.2);color:#ff4d4d;border-radius:8px;padding:6px 10px;font-size:.75rem;font-weight:600;cursor:pointer;transition:all .15s}
    .remove-btn:hover{background:rgba(255,77,77,.2)}

    /* ORDER SUMMARY */
    .summary{background:var(--card);border:1px solid var(--border);border-radius:20px;padding:28px;position:sticky;top:calc(var(--nav-h) + 20px)}
    .sum-title{font-family:'Syne',sans-serif;font-weight:800;font-size:1.1rem;margin-bottom:22px}
    .sum-row{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;font-size:.87rem}
    .sum-row .label{color:var(--muted)}
    .sum-row .val{font-weight:500}
    .sum-divider{border:none;border-top:1px solid var(--border);margin:16px 0}
    .sum-total{display:flex;justify-content:space-between;align-items:center;font-family:'Syne',sans-serif;font-weight:800;font-size:1.1rem;margin-bottom:22px}
    .sum-total .tot-val{color:var(--accent)}
    .checkout-btn{display:block;width:100%;padding:15px;background:var(--accent);color:#fff;border:none;border-radius:14px;font-family:'Syne',sans-serif;font-size:1rem;font-weight:700;cursor:pointer;text-align:center;text-decoration:none;transition:all .2s;box-shadow:0 6px 24px rgba(255,92,43,.3)}
    .checkout-btn:hover{background:#e04d22;transform:translateY(-2px);box-shadow:0 10px 30px rgba(255,92,43,.4)}
    .clear-btn{display:block;width:100%;margin-top:10px;padding:10px;background:transparent;color:var(--muted);border:1px solid var(--border);border-radius:14px;font-size:.83rem;font-weight:500;cursor:pointer;transition:all .2s}
    .clear-btn:hover{border-color:#ff4d4d;color:#ff4d4d}

    @media(max-width:768px){
      .page{grid-template-columns:1fr;padding:calc(var(--nav-h)+28px) 16px 60px}
      nav{padding:0 18px}
    }
  </style>
</head>
<body>

<nav>
  <a class="logo" href="index.jsp">Fork<span>Dash</span></a>
  <div class="nav-r">
    <a href="restaurant" class="nl">Restaurants</a>
    <a href="cart" class="nl on">🛒 Cart <% if(count > 0){ %><span class="cart-badge"><%= count %></span><% } %></a>
    <a href="logout" class="nl" style="color:#ff5555">Logout</a>
  </div>
</nav>

<div class="page">

  <% if (items.isEmpty()) { %>
  <div class="empty">
    <div class="empty-ico">🛒</div>
    <h2>Your cart is empty</h2>
    <p>Looks like you haven't added anything yet. Browse our restaurants and find something delicious!</p>
    <a href="restaurant" class="btn-primary">Browse Restaurants →</a>
  </div>

  <% } else { %>

  <!-- LEFT: CART ITEMS -->
  <div>
    <div class="eye">Your Order</div>
    <h1 class="ptitle">My Cart (<%= count %> item<%= count != 1 ? "s" : "" %>)</h1>
    <div class="cart-items">
      <% for (CartItem item : items) { %>
      <div class="cart-item">
        <div class="item-ico">🍽️</div>
        <div class="item-info">
          <div class="item-name"><%= item.getItemName() %></div>
          <div class="item-rest">📍 <%= item.getRestaurant() %></div>
        </div>

        <!-- DECREASE -->
        <form method="post" action="cart" style="display:inline">
          <input type="hidden" name="action" value="decrease"/>
          <input type="hidden" name="itemId" value="<%= item.getItemId() %>"/>
          <div class="qty-ctrl">
            <button type="submit" class="qty-btn">−</button>
          </div>
        </form>

        <span class="qty-num"><%= item.getQuantity() %></span>

        <!-- INCREASE -->
        <form method="post" action="cart" style="display:inline">
          <input type="hidden" name="action" value="increase"/>
          <input type="hidden" name="itemId" value="<%= item.getItemId() %>"/>
          <button type="submit" class="qty-btn">+</button>
        </form>

        <div class="item-price">₹<%= String.format("%.0f", item.getSubtotal()) %></div>

        <!-- REMOVE -->
        <form method="post" action="cart" style="display:inline">
          <input type="hidden" name="action" value="remove"/>
          <input type="hidden" name="itemId" value="<%= item.getItemId() %>"/>
          <button type="submit" class="remove-btn">✕</button>
        </form>
      </div>
      <% } %>
    </div>
  </div>

  <!-- RIGHT: ORDER SUMMARY -->
  <div class="summary">
    <div class="sum-title">Order Summary</div>

    <% for (CartItem item : items) { %>
    <div class="sum-row">
      <span class="label"><%= item.getItemName() %> × <%= item.getQuantity() %></span>
      <span class="val">₹<%= String.format("%.0f", item.getSubtotal()) %></span>
    </div>
    <% } %>

    <hr class="sum-divider"/>

    <div class="sum-row">
      <span class="label">Subtotal</span>
      <span class="val">₹<%= String.format("%.0f", total) %></span>
    </div>
    <div class="sum-row">
      <span class="label">Delivery Fee</span>
      <span class="val" style="color:#22c55e">FREE</span>
    </div>
    <div class="sum-row">
      <span class="label">Taxes (5%)</span>
      <span class="val">₹<%= String.format("%.0f", total * 0.05) %></span>
    </div>

    <hr class="sum-divider"/>

    <div class="sum-total">
      <span>Total</span>
      <span class="tot-val">₹<%= String.format("%.0f", total * 1.05) %></span>
    </div>

    <a href="checkout" class="checkout-btn">Proceed to Checkout →</a>

    <!-- CLEAR CART -->
    <form method="post" action="cart">
      <input type="hidden" name="action" value="clear"/>
      <button type="submit" class="clear-btn">🗑 Clear Cart</button>
    </form>
  </div>

  <% } %>
</div>

</body>
</html>
