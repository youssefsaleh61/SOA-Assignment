<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Service</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
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
            max-width: 900px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        h2 {
            color: #333;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
            margin-top: 30px;
        }
        
        .input-group {
            margin: 15px 0;
        }
        
        label {
            display: inline-block;
            width: 150px;
            font-weight: bold;
        }
        
        input, select {
            padding: 8px;
            margin-right: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 200px;
        }
        
        button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 5px;
        }
        
        button:hover {
            background-color: #45a049;
        }
        
        button.secondary {
            background-color: #008CBA;
        }
        
        button.secondary:hover {
            background-color: #007399;
        }
        
        button.danger {
            background-color: #f44336;
        }
        
        button.danger:hover {
            background-color: #da190b;
        }
        
        .result {
            margin-top: 20px;
            padding: 15px;
            border-radius: 4px;
            display: none;
        }
        
        .result.success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            display: block;
        }
        
        .result.error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            display: block;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 3px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .status-200 {
            background-color: #28a745;
            color: white;
        }
        
        .status-error {
            background-color: #dc3545;
            color: white;
        }
        
        .data-field {
            margin: 8px 0;
            padding: 8px;
            background-color: rgba(255, 255, 255, 0.5);
            border-radius: 3px;
        }
        
        .data-label {
            font-weight: bold;
            margin-right: 5px;
        }
        
        .product-list {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
            background-color: #f9f9f9;
        }
        
        .product-item {
            padding: 8px;
            margin: 5px 0;
            background-color: white;
            border-radius: 3px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        hr {
            margin: 30px 0;
            border: none;
            border-top: 2px solid #ddd;
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
    <h2>Create New Order</h2>

    <div class="input-group">
        <label for="customerId">Customer ID:</label>
        <input type="number" id="customerId" placeholder="Enter customer ID" />
    </div>

    <div class="input-group">
        <label for="totalAmount">Total Amount:</label>
        <input type="number" id="totalAmount" step="0.01" placeholder="Enter total amount" />
    </div>

    <h3>Products</h3>
    <div class="product-list" id="productList">
        <div class="product-item">
            <div>
                <input type="number" class="productId" placeholder="Product ID" style="width: 120px;" />
                <input type="number" class="productQuantity" placeholder="Quantity" style="width: 120px;" />
            </div>
        </div>
    </div>

    <button class="secondary" onclick="addProduct()">Add Another Product</button>
    <button onclick="createOrder()">Create Order</button>

    <div id="createResult" class="result"></div>

    <hr />

    <h2>Get Order Details</h2>

    <div class="input-group">
        <label for="orderId">Order ID:</label>
        <input type="number" id="orderId" placeholder="Enter order ID" />
        <button onclick="getOrder()">Get Order</button>
    </div>

    <div id="getResult" class="result"></div>
</div>

<script>
function addProduct() {
    const productList = document.getElementById("productList");
    const productItem = document.createElement("div");
    productItem.className = "product-item";
    productItem.innerHTML = 
        '<div>' +
        '<input type="number" class="productId" placeholder="Product ID" style="width: 120px;" />' +
        '<input type="number" class="productQuantity" placeholder="Quantity" style="width: 120px;" />' +
        '</div>' +
        '<button class="danger" onclick="removeProduct(this)">Remove</button>';
    productList.appendChild(productItem);
}

function removeProduct(button) {
    button.parentElement.remove();
}

function createOrder() {
    const customerId = document.getElementById("customerId").value;
    const totalAmount = document.getElementById("totalAmount").value;

    if (!customerId || !totalAmount) {
        alert("Please enter customer ID and total amount");
        return;
    }

    // Collect all products
    const productIds = document.querySelectorAll(".productId");
    const productQuantities = document.querySelectorAll(".productQuantity");
    const products = [];

    for (let i = 0; i < productIds.length; i++) {
        const productId = productIds[i].value;
        const quantity = productQuantities[i].value;
        
        if (productId && quantity) {
            products.push({
                product_id: parseInt(productId, 10),
                quantity: parseInt(quantity, 10)
            });
        }
    }

    if (products.length === 0) {
        alert("Please add at least one product");
        return;
    }

    const body = {
        customer_id: parseInt(customerId, 10),
        products: products,
        total_amount: parseFloat(totalAmount)
    };

    console.log("Creating order with data:", body);

    fetch("http://localhost:5001/api/orders/create", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(body)
    })
        .then(response => {
            console.log("Response status:", response.status);
            return response.json().then(data => {
                console.log("Response data:", data);
                return { status: response.status, body: data };
            });
        })
        .then(res => {
            const resultDiv = document.getElementById("createResult");
            const isSuccess = res.status === 200;
            
            resultDiv.className = isSuccess ? "result success" : "result error";
            
            let html = '<span class="status-badge status-' + (isSuccess ? '200' : 'error') + '">Status: ' + res.status + '</span>';
            
            if (isSuccess) {
                html += '<div class="data-field">' +
                    '<span class="data-label">Message:</span>' + (res.body.message || 'N/A') +
                    '</div>' +
                    '<div class="data-field">' +
                    '<span class="data-label">Order ID:</span>' + (res.body.data !== undefined ? res.body.data : 'N/A') +
                    '</div>';
            } else {
                html += '<div class="data-field">' + (res.body.error || res.body.message || 'Unknown error') + '</div>';
            }
            
            resultDiv.innerHTML = html;
        })
        .catch(err => {
            console.error("Fetch error:", err);
            const resultDiv = document.getElementById("createResult");
            resultDiv.className = "result error";
            resultDiv.innerHTML = '<span class="status-badge status-error">Error</span><div class="data-field">Error calling Flask API. Check console for details.</div>';
        });
}

function getOrder() {
    const orderId = document.getElementById("orderId").value;

    if (!orderId) {
        alert("Please enter an order ID");
        return;
    }

    fetch("http://localhost:5001/api/orders/" + orderId)
        .then(response => {
            console.log("Response status:", response.status);
            return response.json().then(data => {
                console.log("Response data:", data);
                return { status: response.status, body: data };
            });
        })
        .then(res => {
            const resultDiv = document.getElementById("getResult");
            const isSuccess = res.status === 200;
            
            resultDiv.className = isSuccess ? "result success" : "result error";
            
            let html = '<span class="status-badge status-' + (isSuccess ? '200' : 'error') + '">Status: ' + res.status + '</span>';
            
            if (isSuccess && res.body.data) {
                html += '<div class="data-field">' +
                    '<span class="data-label">Customer ID:</span>' + (res.body.data.customer_id || 'N/A') +
                    '</div>' +
                    '<div class="data-field">' +
                    '<span class="data-label">Total Amount:</span>' + (res.body.data.total_amount || 'N/A') +
                    '</div>' +
                    '<div class="data-field">' +
                    '<span class="data-label">Products:</span>' +
                    '</div>';
                
                if (res.body.data.products && res.body.data.products.length > 0) {
                    html += '<div class="product-list">';
                    res.body.data.products.forEach(function(product, index) {
                        html += '<div class="product-item">' +
                            '<span>Product ID: ' + product.product_id + ', Quantity: ' + product.quantity + '</span>' +
                            '</div>';
                    });
                    html += '</div>';
                }
            } else {
                html += '<div class="data-field">' + (res.body.error || res.body.message || 'Unknown error') + '</div>';
            }
            
            resultDiv.innerHTML = html;
        })
        .catch(err => {
            console.error("Fetch error:", err);
            const resultDiv = document.getElementById("getResult");
            resultDiv.className = "result error";
            resultDiv.innerHTML = '<span class="status-badge status-error">Error</span><div class="data-field">Error calling Flask API. Check console for details.</div>';
        });
}
</script>

</body>
</html>
