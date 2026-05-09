<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="ma.ac.esi.moroccocraft.model.Product" %>
<%@ page import="ma.ac.esi.moroccocraft.model.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoroccoCraft — Mon Panier</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f0e8; color: #1a0f0a; min-height: 100vh; }

        nav {
            background: #1a0f0a; padding: 0 40px;
            display: flex; align-items: center; justify-content: space-between; height: 60px;
            position: sticky; top: 0; z-index: 100;
        }
        .nav-logo { font-family: 'Playfair Display', serif; color: #f4c97a; font-size: 20px; font-weight: 700; text-decoration: none; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-link { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; transition: color .2s; }
        .nav-link:hover { color: #f4c97a; }
        .btn-logout {
            background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.7); padding: 7px 14px; border-radius: 6px;
            font-size: 13px; cursor: pointer; font-family: 'Inter', sans-serif;
        }
        .btn-logout:hover { background: rgba(255,255,255,0.15); color: #fff; }

        .main {
            max-width: 900px; margin: 48px auto; padding: 0 20px;
            display: grid; grid-template-columns: 1fr 320px; gap: 28px; align-items: start;
        }

        .page-title { font-family: 'Playfair Display', serif; font-size: 30px; color: #1a0f0a; margin-bottom: 6px; }
        .page-sub   { color: #7a6a5a; font-size: 14px; margin-bottom: 28px; }

        .cart-item {
            background: #fff; border-radius: 12px; border: 1px solid #e8e0d4;
            padding: 20px; display: flex; gap: 18px; align-items: center;
            margin-bottom: 14px; transition: box-shadow .2s;
        }
        .cart-item:hover { box-shadow: 0 4px 16px rgba(44,24,16,0.08); }

        .item-img {
            width: 80px; height: 80px; border-radius: 10px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
            font-size: 32px;
        }
        .item-img.cat-Tapis   { background: linear-gradient(135deg,#fef3c7,#fde68a); }
        .item-img.cat-Poterie { background: linear-gradient(135deg,#e8ddd0,#d4c4b0); }
        .item-img.cat-Bijoux  { background: linear-gradient(135deg,#fef9c3,#fef08a); }
        .item-img.cat-Cuir    { background: linear-gradient(135deg,#fed7aa,#fdba74); }
        .item-img.cat-Laiton  { background: linear-gradient(135deg,#d1fae5,#a7f3d0); }
        .item-img.cat-Autre   { background: linear-gradient(135deg,#e0e7ff,#c7d2fe); }

        .item-info { flex: 1; }
        .item-category { font-size: 11px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; color: #8b4513; margin-bottom: 4px; }
        .item-title    { font-family: 'Playfair Display', serif; font-size: 17px; font-weight: 700; color: #1a0f0a; margin-bottom: 4px; }
        .item-artisan  { font-size: 13px; color: #7a6a5a; }
        .item-price    { font-size: 18px; font-weight: 700; color: #1a0f0a; flex-shrink: 0; }

        .btn-remove {
            background: #fee2e2; color: #991b1b; border: none;
            border-radius: 6px; padding: 7px 12px; font-size: 12px;
            font-family: 'Inter', sans-serif; cursor: pointer; flex-shrink: 0; transition: all .2s;
        }
        .btn-remove:hover { background: #fecaca; }

        .empty-cart {
            background: #fff; border-radius: 12px; border: 1px solid #e8e0d4;
            padding: 64px; text-align: center; color: #7a6a5a; grid-column: 1/-1;
        }
        .empty-cart .icon { font-size: 56px; margin-bottom: 16px; }
        .empty-cart h3 { font-family: 'Playfair Display', serif; font-size: 22px; color: #1a0f0a; margin-bottom: 8px; }
        .empty-cart p  { font-size: 14px; margin-bottom: 24px; }
        .btn-shop {
            display: inline-block; padding: 12px 28px; background: #8b4513; color: #fff;
            border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 500;
            transition: background .2s;
        }
        .btn-shop:hover { background: #6b3410; }

        /* Récapitulatif */
        .summary-card {
            background: #fff; border-radius: 12px; border: 1px solid #e8e0d4;
            padding: 28px; position: sticky; top: 80px;
        }
        .summary-title { font-family: 'Playfair Display', serif; font-size: 20px; color: #1a0f0a; margin-bottom: 24px; }
        .summary-line {
            display: flex; justify-content: space-between; align-items: center;
            padding: 10px 0; border-bottom: 1px solid #f0e8dc; font-size: 14px; color: #5a4a3a;
        }
        .summary-line:last-of-type { border-bottom: none; }
        .summary-total {
            display: flex; justify-content: space-between; align-items: center;
            padding: 16px 0 0; border-top: 2px solid #1a0f0a; margin-top: 8px;
        }
        .summary-total-label { font-size: 16px; font-weight: 600; color: #1a0f0a; }
        .summary-total-price { font-family: 'Playfair Display', serif; font-size: 24px; font-weight: 700; color: #1a0f0a; }

        /* ===== BOUTON COMMANDER — lien simple vers checkout ===== */
        .btn-order {
            display: block; width: 100%; padding: 14px; text-align: center;
            background: linear-gradient(135deg,#a05020,#7a3a14);
            color: #fff; border: none; border-radius: 10px; font-size: 15px; font-weight: 600;
            font-family: 'Inter', sans-serif; cursor: pointer; margin-top: 20px;
            text-decoration: none; transition: all .2s;
        }
        .btn-order:hover {
            background: linear-gradient(135deg,#7a3a14,#5a2a0a);
            box-shadow: 0 6px 20px rgba(139,69,19,0.35);
        }

        .btn-clear-cart {
            width: 100%; padding: 10px; background: transparent; color: #7a6a5a;
            border: 1.5px solid #d4c4b0; border-radius: 8px; font-size: 13px;
            font-family: 'Inter', sans-serif; cursor: pointer; margin-top: 10px; transition: all .2s;
        }
        .btn-clear-cart:hover { border-color: #991b1b; color: #991b1b; }

        @media (max-width: 768px) { .main { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<%
    User connectedUser = (User) session.getAttribute("user");
    List<Product> cart = (List<Product>) request.getAttribute("cart");
    double total        = cart != null ? (double) request.getAttribute("total") : 0.0;
    int nbItems         = cart != null ? cart.size() : 0;

    String[] catEmojis = {"🏺","🎨","💎","👜","🪔","✦"};
    String[] catNames  = {"Tapis","Poterie","Bijoux","Cuir","Laiton","Autre"};
%>

<nav>
    <a class="nav-logo" href="<%= request.getContextPath() %>/ProductController">🏺 MoroccoCraft</a>
    <div class="nav-right">
        <a class="nav-link" href="<%= request.getContextPath() %>/ProductController">← Continuer mes achats</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/OrderController?view=mes-commandes">📦 Mes commandes</a>
        <span style="color:rgba(255,255,255,0.6);font-size:14px">
            <%= connectedUser != null ? connectedUser.getName() : "" %>
        </span>
        <form action="<%= request.getContextPath() %>/LogoutController" method="post" style="margin:0">
            <button type="submit" class="btn-logout">Déconnexion</button>
        </form>
    </div>
</nav>

<div class="main">

    <div>
        <h1 class="page-title">🛍 Mon Panier</h1>
        <p class="page-sub"><%= nbItems %> article(s) dans votre panier</p>

        <% if (cart == null || cart.isEmpty()) { %>
            <div class="empty-cart">
                <div class="icon">🛒</div>
                <h3>Votre panier est vide</h3>
                <p>Découvrez notre collection d'artisanat marocain<br>et ajoutez vos coups de cœur.</p>
                <a class="btn-shop" href="<%= request.getContextPath() %>/ProductController">
                    Découvrir les produits →
                </a>
            </div>
        <% } else { %>
            <% for (Product p : cart) {
                String emoji = "🏺";
                String catClass = "cat-Autre";
                for (int i = 0; i < catNames.length; i++) {
                    if (catNames[i].equals(p.getCategory())) { emoji = catEmojis[i]; catClass = "cat-" + catNames[i]; break; }
                }
            %>
                <div class="cart-item">
                    <div class="item-img <%= catClass %>"><%= emoji %></div>
                    <div class="item-info">
                        <div class="item-category"><%= p.getCategory() %></div>
                        <div class="item-title"><%= p.getTitle() %></div>
                        <div class="item-artisan">Par <%= p.getArtisanName() %></div>
                    </div>
                    <div class="item-price"><%= String.format("%.2f", p.getPrice()) %> MAD</div>
                    <form action="<%= request.getContextPath() %>/CartController" method="post">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="id" value="<%= p.getId() %>">
                        <button type="submit" class="btn-remove">✕ Retirer</button>
                    </form>
                </div>
            <% } %>
        <% } %>
    </div>

    <!-- Récapitulatif (affiché seulement si panier non vide) -->
    <% if (cart != null && !cart.isEmpty()) { %>
    <div class="summary-card">
        <div class="summary-title">Récapitulatif</div>
        <div class="summary-line">
            <span>Sous-total (<%= nbItems %> article<%= nbItems > 1 ? "s" : "" %>)</span>
            <span><%= String.format("%.2f", total) %> MAD</span>
        </div>
        <div class="summary-line">
            <span>Livraison</span>
            <span style="color:#166534;font-weight:500">Gratuite</span>
        </div>
        <div class="summary-total">
            <span class="summary-total-label">Total</span>
            <span class="summary-total-price"><%= String.format("%.2f", total) %> MAD</span>
        </div>

        <%-- BOUTON COMMANDER : lien simple GET vers /CheckoutController --%>
        <a class="btn-order" href="<%= request.getContextPath() %>/CheckoutController">
            ✓ Passer la commande
        </a>

        <form action="<%= request.getContextPath() %>/CartController" method="post">
            <input type="hidden" name="action" value="clear">
            <button type="submit" class="btn-clear-cart">🗑 Vider le panier</button>
        </form>
    </div>
    <% } %>

</div>
</body>
</html>
