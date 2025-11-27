<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Catalog - E-Commerce System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
        }
        
        .header {
            background-color: #4CAF50;
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .header h1 {
            font-size: 28px;
        }
        
        .nav {
            background-color: #45a049;
            padding: 10px 0;
        }
        
        .nav-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            gap: 20px;
        }
        
        .nav a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        
        .nav a:hover {
            background-color: #3d8b40;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .controls {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .search-box input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        
        button:hover {
            background-color: #45a049;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
            display: none;
        }
        
        .loading.show {
            display: block;
        }
        
        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .product-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .product-image {
            width: 100%;
            height: 200px;
            background-color: #e0e0e0;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .product-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .product-info {
            margin: 10px 0;
        }
        
        .product-label {
            font-weight: bold;
            color: #666;
            font-size: 14px;
        }
        
        .product-value {
            color: #333;
            font-size: 14px;
        }
        
        .stock-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .stock-available {
            background-color: #d4edda;
            color: #155724;
        }
        
        .stock-low {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .stock-out {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .product-actions {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }
        
        .btn-check {
            flex: 1;
            background-color: #17a2b8;
        }
        
        .btn-check:hover {
            background-color: #138496;
        }
        
        .no-products {
            text-align: center;
            padding: 60px 20px;
            color: #666;
            background-color: white;
            border-radius: 8px;
        }
        
        .no-products h3 {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="header">
    <div class="header-content">
        <h1>🛒 E-Commerce System</h1>
    </div>
</div>

<div class="nav">
    <div class="nav-content">
        <a href="index.jsp">Product Catalog</a>
        <a href="InventoryService.jsp">Inventory Management</a>
        <a href="OrderService.jsp">Order Management</a>
    </div>
</div>

<div class="container">
    <div class="controls">
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="Search products by name..." />
            <button onclick="searchProducts()">Search</button>
            <button onclick="loadAllProducts()">Show All</button>
        </div>
    </div>
    
    <div id="loadingMessage" class="loading">
        <h3>Loading products...</h3>
    </div>
    
    <div id="errorMessage" class="error-message"></div>
    
    <div id="productGrid" class="product-grid"></div>
</div>

<script>
// Sample product IDs to fetch (you can modify this based on your database)
const PRODUCT_IDS = [1, 2, 3, 4, 5];
let allProducts = [];

function showLoading(show) {
    const loadingDiv = document.getElementById("loadingMessage");
    if (show) {
        loadingDiv.classList.add("show");
    } else {
        loadingDiv.classList.remove("show");
    }
}

function showError(message) {
    const errorDiv = document.getElementById("errorMessage");
    errorDiv.textContent = message;
    errorDiv.classList.add("show");
    setTimeout(function() {
        errorDiv.classList.remove("show");
    }, 5000);
}

function getStockStatus(quantity) {
    if (quantity === 0) {
        return { class: 'stock-out', text: 'Out of Stock' };
    } else if (quantity < 10) {
        return { class: 'stock-low', text: 'Low Stock' };
    } else {
        return { class: 'stock-available', text: 'In Stock' };
    }
}

function createProductCard(product) {
    const stockStatus = getStockStatus(product.quantity);
    
    return '<div class="product-card">' +
        '<div class="product-image">📦</div>' +
        '<div class="product-name">' + product.product_name + '</div>' +
        '<div class="product-info">' +
        '<span class="product-label">Product ID:</span> ' +
        '<span class="product-value">#' + product.product_id + '</span>' +
        '</div>' +
        '<div class="product-info">' +
        '<span class="product-label">Available:</span> ' +
        '<span class="product-value">' + product.quantity + ' units</span>' +
        '</div>' +
        '<div class="product-info">' +
        '<span class="stock-badge ' + stockStatus.class + '">' + stockStatus.text + '</span>' +
        '</div>' +
        '<div class="product-actions">' +
        '<button class="btn-check" onclick="checkProductDetail(' + product.product_id + ')">Check Details</button>' +
        '</div>' +
        '</div>';
}

function displayProducts(products) {
    const productGrid = document.getElementById("productGrid");
    
    if (products.length === 0) {
        productGrid.innerHTML = '<div class="no-products">' +
            '<h3>No products found</h3>' +
            '<p>Try adjusting your search or check back later.</p>' +
            '</div>';
        return;
    }
    
    let html = '';
    products.forEach(function(product) {
        html += createProductCard(product);
    });
    
    productGrid.innerHTML = html;
}

function loadAllProducts() {
    showLoading(true);
    allProducts = [];
    let loadedCount = 0;
    let errorCount = 0;
    
    PRODUCT_IDS.forEach(function(productId) {
        fetch("http://localhost:5002/api/inventory/check/" + productId)
            .then(response => response.json())
            .then(data => {
                loadedCount++;
                
                if (data.data) {
                    allProducts.push({
                        product_id: productId,
                        product_name: data.data.product_name,
                        quantity: data.data.quantity
                    });
                } else {
                    errorCount++;
                }
                
                if (loadedCount === PRODUCT_IDS.length) {
                    showLoading(false);
                    allProducts.sort(function(a, b) {
                        return a.product_id - b.product_id;
                    });
                    displayProducts(allProducts);
                    
                    if (errorCount > 0) {
                        showError(errorCount + ' products could not be loaded');
                    }
                }
            })
            .catch(err => {
                console.error("Error loading product " + productId + ":", err);
                loadedCount++;
                errorCount++;
                
                if (loadedCount === PRODUCT_IDS.length) {
                    showLoading(false);
                    displayProducts(allProducts);
                    showError("Some products could not be loaded. Please check if the Inventory Service is running.");
                }
            });
    });
}

function searchProducts() {
    const searchTerm = document.getElementById("searchInput").value.toLowerCase().trim();
    
    if (!searchTerm) {
        displayProducts(allProducts);
        return;
    }
    
    const filtered = allProducts.filter(function(product) {
        return product.product_name.toLowerCase().includes(searchTerm);
    });
    
    displayProducts(filtered);
}

function checkProductDetail(productId) {
    window.location.href = 'InventoryService.jsp?productId=' + productId;
}

// Handle Enter key in search box
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById("searchInput");
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchProducts();
            }
        });
    }
    
    // Load products on page load
    loadAllProducts();
});
</script>

</body>
</html>
