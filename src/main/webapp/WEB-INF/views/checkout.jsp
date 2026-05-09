<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, ma.ac.esi.moroccocraft.model.Product, ma.ac.esi.moroccocraft.model.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>MoroccoCraft — Confirmer la commande</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; background: #f5f0e8; color: #1a0f0a; }
nav {
    background: #1a0f0a; padding: 0 40px;
    display: flex; align-items: center; justify-content: space-between; height: 60px;
}
.nav-logo { font-family: 'Playfair Display', serif; color: #f4c97a; font-size: 20px; font-weight: 700; text-decoration: none; }
.nav-link  { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; }
.nav-link:hover { color: #f4c97a; }

.main { max-width: 980px; margin: 48px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 360px; gap: 28px; align-items: start; }

/* Étapes */
.steps { display: flex; align-items: center; gap: 0; margin-bottom: 32px; grid-column: 1/-1; }
.step { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #b0a090; }
.step.active { color: #8b4513; font-weight: 600; }
.step.done   { color: #166534; }
.step-num {
    width: 28px; height: 28px; border-radius: 50%; border: 2px solid #d4c4b0;
    display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 600;
}
.step.active .step-num { border-color: #8b4513; background: #8b4513; color: #fff; }
.step.done .step-num   { border-color: #166534; background: #dcfce7; color: #166534; }
.step-line { flex: 1; height: 1px; background: #d4c4b0; margin: 0 12px; }

/* Formulaire */
.card { background: #fff; border-radius: 14px; border: 1px solid #e8e0d4; padding: 32px; }
.card-title { font-family: 'Playfair Display', serif; font-size: 22px; color: #1a0f0a; margin-bottom: 6px; }
.card-sub   { color: #7a6a5a; font-size: 13px; margin-bottom: 28px; }

.alert-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; padding: 12px 16px; border-radius: 8px; font-size: 14px; margin-bottom: 20px; }

.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.form-group { margin-bottom: 18px; }
label { display: block; font-size: 12px; font-weight: 500; color: #5a4a3a; margin-bottom: 5px; letter-spacing: 0.3px; }
input[type="text"], input[type="tel"], textarea {
    width: 100%; padding: 12px 14px; border: 1.5px solid #ddd0c0; border-radius: 8px;
    font-size: 14px; font-family: 'Inter', sans-serif; background: #fff; color: #1a0f0a;
    outline: none; transition: border-color .2s;
}
input:focus, textarea:focus { border-color: #8b4513; box-shadow: 0 0 0 3px rgba(139,69,19,0.08); }
textarea { height: 80px; resize: vertical; }

.info-box {
    background: #fffbeb; border: 1px solid #fcd34d; border-radius: 10px;
    padding: 14px 16px; margin-bottom: 24px; font-size: 13px; color: #92400e; line-height: 1.6;
}
.info-box strong { display: block; margin-bottom: 4px; font-size: 14px; }

.btn-order {
    width: 100%; padding: 14px; background: linear-gradient(135deg, #a05020, #7a3a14);
    color: #fff; border: none; border-radius: 10px; font-size: 15px; font-weight: 600;
    font-family: 'Inter', sans-serif; cursor: pointer; transition: all .2s;
}
.btn-order:hover { background: linear-gradient(135deg,#7a3a14,#5a2a0a); box-shadow: 0 6px 20px rgba(139,69,19,0.3); }

/* Récap commande */
.recap-card { background: #fff; border-radius: 14px; border: 1px solid #e8e0d4; padding: 24px; position: sticky; top: 80px; }
.recap-title { font-family: 'Playfair Display', serif; font-size: 18px; color: #1a0f0a; margin-bottom: 20px; }
.recap-item { display: flex; align-items: center; gap: 12px; padding: 10px 0; border-bottom: 1px solid #f0e8dc; }
.recap-item:last-of-type { border-bottom: none; }
.recap-emoji { font-size: 24px; width: 36px; text-align: center; }
.recap-info { flex: 1; }
.recap-name  { font-size: 13px; font-weight: 500; color: #1a0f0a; }
.recap-cat   { font-size: 11px; color: #9a8a7a; }
.recap-price { font-size: 14px; font-weight: 600; color: #1a0f0a; }
.recap-total {
    display: flex; justify-content: space-between; padding: 16px 0 0;
    border-top: 2px solid #1a0f0a; margin-top: 8px;
    font-weight: 700; font-size: 18px; color: #1a0f0a;
}

@media (max-width: 768px) { .main { grid-template-columns: 1fr; } .form-row { grid-template-columns: 1fr; } }
</style>
</head>
<body>
<%
    User user   = (User) session.getAttribute("user");
    List<Product> cart = (List<Product>) request.getAttribute("cart");
    double total = (double) request.getAttribute("total");
    String error = (String) request.getAttribute("error");
    String[] catEmojis = {"🏺","🎨","💎","👜","🪔","✦"};
    String[] catNames  = {"Tapis","Poterie","Bijoux","Cuir","Laiton","Autre"};
%>
<nav>
    <a class="nav-logo" href="<%= request.getContextPath() %>/ProductController">🏺 MoroccoCraft</a>
    <a class="nav-link" href="<%= request.getContextPath() %>/CartController">← Retour au panier</a>
</nav>

<div class="main">

    <!-- Étapes -->
    <div class="steps">
        <div class="step done"><div class="step-num">✓</div> Panier</div>
        <div class="step-line"></div>
        <div class="step active"><div class="step-num">2</div> Livraison</div>
        <div class="step-line"></div>
        <div class="step"><div class="step-num">3</div> Confirmation</div>
    </div>

    <!-- Formulaire livraison -->
    <div class="card">
        <div class="card-title">📍 Informations de livraison</div>
        <p class="card-sub">L'artisan vous contactera à ce numéro pour organiser la livraison.</p>

        <% if (error != null) { %><div class="alert-error">⚠ <%= error %></div><% } %>

        <div class="info-box">
            <strong>💡 Comment ça marche ?</strong>
            Une fois votre commande passée, l'artisan reçoit une notification.
            Il confirme votre commande et vous indique une date de livraison estimée
            ainsi qu'un message personnalisé. Vous serez notifié à chaque étape.
        </div>

        <form action="<%= request.getContextPath() %>/CheckoutController" method="post">

            <div class="form-row">
                <div class="form-group">
                    <label>Nom complet *</label>
                    <input type="text" name="name" value="<%= user.getName() %>" required>
                </div>
                <div class="form-group">
                    <label>Téléphone * <span style="color:#9a8a7a">(l'artisan vous appellera)</span></label>
                    <input type="tel" name="phone" placeholder="06 XX XX XX XX" required>
                </div>
            </div>

            <div class="form-group">
                <label>Adresse complète *</label>
                <input type="text" name="address" placeholder="N° rue, quartier, appartement..." required>
            </div>

            <div class="form-group">
                <label>Ville *</label>
                <input type="text" name="city" value="<%= user.getCity() != null ? user.getCity() : "" %>" required>
            </div>

            <div class="form-group">
                <label>Note pour l'artisan <span style="color:#9a8a7a">(optionnel)</span></label>
                <textarea name="buyerNote" placeholder="Instructions particulières, disponibilités pour la livraison..."></textarea>
            </div>

            <button type="submit" class="btn-order">
                ✓ Confirmer ma commande — <%= String.format("%.2f", total) %> MAD
            </button>
        </form>
    </div>

    <!-- Récap à droite -->
    <div class="recap-card">
        <div class="recap-title">Votre commande</div>
        <% if (cart != null) { for (Product p : cart) {
               String emoji = "🏺";
               for (int i=0;i<catNames.length;i++) if(catNames[i].equals(p.getCategory())) { emoji=catEmojis[i]; break; }
        %>
            <div class="recap-item">
                <div class="recap-emoji"><%= emoji %></div>
                <div class="recap-info">
                    <div class="recap-name"><%= p.getTitle() %></div>
                    <div class="recap-cat"><%= p.getCategory() %> · Par <%= p.getArtisanName() %></div>
                </div>
                <div class="recap-price"><%= String.format("%.2f", p.getPrice()) %> MAD</div>
            </div>
        <% } } %>
        <div class="recap-total">
            <span>Total</span>
            <span><%= String.format("%.2f", total) %> MAD</span>
        </div>
    </div>
</div>
</body>
</html>
