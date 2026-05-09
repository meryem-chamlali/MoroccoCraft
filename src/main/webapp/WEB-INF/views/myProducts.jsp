<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="ma.ac.esi.moroccocraft.model.Product" %>
<%@ page import="ma.ac.esi.moroccocraft.model.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>MoroccoCraft — Mes produits</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f0e8; min-height: 100vh; }
        nav {
            background: #1a0f0a; padding: 0 40px;
            display: flex; align-items: center; justify-content: space-between; height: 60px;
        }
        .nav-logo { font-family: 'Playfair Display', serif; color: #f4c97a; font-size: 20px; font-weight: 700; text-decoration: none; }
        .nav-right { display: flex; align-items: center; gap: 20px; }
        .nav-link { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; }
        .nav-link:hover { color: #f4c97a; }
        .btn-logout {
            background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.7); padding: 7px 16px; border-radius: 6px;
            font-size: 13px; cursor: pointer; font-family: 'Inter', sans-serif;
        }
        .btn-logout:hover { background: rgba(255,255,255,0.15); color: #fff; }

        .main { max-width: 1000px; margin: 40px auto; padding: 0 20px; }
        .page-header {
            display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px;
        }
        h1 { font-family: 'Playfair Display', serif; font-size: 28px; color: #1a0f0a; }
        .btn-new {
            padding: 11px 24px; background: #8b4513; color: #fff;
            border: none; border-radius: 8px; font-size: 14px; font-weight: 500;
            font-family: 'Inter', sans-serif; cursor: pointer; text-decoration: none; transition: background .2s;
        }
        .btn-new:hover { background: #6b3410; }

        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; border: 1px solid #e8e0d4; }
        thead { background: #f5f0e8; }
        th { padding: 12px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #5a4a3a; letter-spacing: 0.5px; text-transform: uppercase; border-bottom: 1px solid #e8e0d4; }
        td { padding: 14px 16px; font-size: 14px; border-bottom: 1px solid #f0e8dc; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #faf7f2; }

        .product-title { font-weight: 500; color: #1a0f0a; }
        .product-desc  { font-size: 12px; color: #9a8a7a; margin-top: 2px; }

        .status-badge {
            display: inline-block; padding: 4px 10px; border-radius: 12px;
            font-size: 11px; font-weight: 600;
        }
        .status-PENDING  { background: #fef9c3; color: #854d0e; }
        .status-APPROVED { background: #dcfce7; color: #166534; }
        .status-REJECTED { background: #fee2e2; color: #991b1b; }

        .price { font-weight: 600; }

        .btn-edit {
            padding: 6px 14px; background: #fdf5ec; color: #8b4513;
            border: 1px solid #f4d5b8; border-radius: 6px; font-size: 12px;
            font-family: 'Inter', sans-serif; cursor: pointer; text-decoration: none; transition: all .2s;
        }
        .btn-edit:hover { background: #f4d5b8; }

        .btn-delete {
            padding: 6px 14px; background: #fee2e2; color: #991b1b;
            border: 1px solid #fecaca; border-radius: 6px; font-size: 12px;
            font-family: 'Inter', sans-serif; cursor: pointer; margin-left: 6px; transition: all .2s;
        }
        .btn-delete:hover { background: #fecaca; }

        .empty-state { text-align: center; padding: 80px 20px; color: #7a6a5a; }
        .empty-state .icon { font-size: 48px; margin-bottom: 16px; }
        .empty-state p { font-size: 15px; }
        .empty-state a { color: #8b4513; text-decoration: none; font-weight: 500; }
    </style>
</head>
<body>
<%
    User connectedUser = (User) session.getAttribute("user");
    List<Product> myProducts = (List<Product>) request.getAttribute("myProducts");
%>
<nav>
    <a class="nav-logo" href="<%= request.getContextPath() %>/ProductController">🏺 MoroccoCraft</a>
    <div class="nav-right">
        <a class="nav-link" href="<%= request.getContextPath() %>/ProductController">Catalogue</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/SubmitProductController">+ Nouveau produit</a>
        <span style="color:rgba(255,255,255,0.6);font-size:14px"><%= connectedUser != null ? connectedUser.getName() : "" %></span>
        <form action="<%= request.getContextPath() %>/LogoutController" method="post" style="margin:0">
            <button type="submit" class="btn-logout">Déconnexion</button>
        </form>
    </div>
</nav>

<div class="main">
    <div class="page-header">
        <h1>Mes produits</h1>
        <a class="btn-new" href="<%= request.getContextPath() %>/SubmitProductController">+ Ajouter un produit</a>
    </div>

    <% if (myProducts == null || myProducts.isEmpty()) { %>
        <div class="empty-state">
            <div class="icon">🎨</div>
            <p>Vous n'avez pas encore de produits.<br>
               <a href="<%= request.getContextPath() %>/SubmitProductController">Soumettre votre premier produit →</a>
            </p>
        </div>
    <% } else { %>
    <table>
        <thead>
            <tr>
                <th>Produit</th>
                <th>Catégorie</th>
                <th>Prix</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <% for (Product p : myProducts) { %>
            <tr>
                <td>
                    <div class="product-title"><%= p.getTitle() %></div>
                    <% if (p.getDescription() != null && !p.getDescription().isEmpty()) { %>
                        <div class="product-desc">
                            <%= p.getDescription().length() > 60
                                ? p.getDescription().substring(0, 60) + "..."
                                : p.getDescription() %>
                        </div>
                    <% } %>
                </td>
                <td><%= p.getCategory() %></td>
                <td class="price"><%= String.format("%.2f", p.getPrice()) %> MAD</td>
                <td><span class="status-badge status-<%= p.getStatus() %>"><%= p.getStatus() %></span></td>
                <td>
                    <!-- Bouton Modifier -->
                    <a class="btn-edit"
                       href="<%= request.getContextPath() %>/EditProductController?id=<%= p.getId() %>">
                        ✏ Modifier
                    </a>
                    <!-- Bouton Supprimer -->
                    <form style="display:inline"
                          action="<%= request.getContextPath() %>/DeleteProductController" method="post"
                          onsubmit="return confirm('Supprimer ce produit définitivement ?')">
                        <input type="hidden" name="id" value="<%= p.getId() %>">
                        <button type="submit" class="btn-delete">🗑 Supprimer</button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>
