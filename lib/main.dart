<?php
session_start();

// Initialize cart if it doesn't exist
if (!isset($_SESSION['cart'])) {
    $_SESSION['cart'] = [];
    $_SESSION['total'] = 0.0;
    $_SESSION['totalWeight'] = 0.0;
    $_SESSION['payment'] = 0.0;
    $_SESSION['change'] = 0.0;
}

// Add item to cart
if (isset($_POST['addItem'])) {
    $itemName = $_POST['item'];
    $weight = floatval($_POST['weight']);
    
    // Add item to the cart
    if (!isset($_SESSION['cart'][$itemName])) {
        $_SESSION['cart'][$itemName] = 0.0;
    }
    $_SESSION['cart'][$itemName] += $weight;
    
    // Update total and weight
    $_SESSION['totalWeight'] += $weight;
    $_SESSION['total'] += 20.0 * $weight; // Adjust price logic as needed
}

// Remove item from cart
if (isset($_POST['removeItem'])) {
    $itemName = $_POST['item'];
    
    if (isset($_SESSION['cart'][$itemName])) {
        $weight = $_SESSION['cart'][$itemName];
        $_SESSION['total'] -= 20.0 * $weight;
        $_SESSION['totalWeight'] -= $weight;
        unset($_SESSION['cart'][$itemName]);
    }
}

// Handle payment
if (isset($_POST['payment'])) {
    $paymentAmount = floatval($_POST['paymentAmount']);
    $_SESSION['payment'] = $paymentAmount;
    $_SESSION['change'] = $paymentAmount - $_SESSION['total'];
}

// Clear cart
if (isset($_POST['clearCart'])) {
    $_SESSION['cart'] = [];
    $_SESSION['total'] = 0.0;
    $_SESSION['totalWeight'] = 0.0;
    $_SESSION['payment'] = 0.0;
    $_SESSION['change'] = 0.0;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop Management System</title>
    <style>
        .container { width: 80%; margin: 0 auto; }
        .cart, .shop { margin: 20px 0; }
        .item { margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Shop Management System</h1>

        <div class="shop">
            <h2>Add Items to Cart</h2>
            <form action="" method="POST">
                <div class="item">
                    <label for="item">Select Item:</label>
                    <select name="item" id="item">
                        <option value="Fruit">Fruit</option>
                        <option value="Vegetable">Vegetable</option>
                        <option value="Canned Goods">Canned Goods</option>
                        <option value="Condiments">Condiments</option>
                    </select>
                </div>
                <div class="item">
                    <label for="weight">Weight (kg):</label>
                    <input type="number" step="0.01" name="weight" required>
                </div>
                <button type="submit" name="addItem">Add to Cart</button>
            </form>
        </div>

        <div class="cart">
            <h2>Your Cart</h2>
            <ul>
                <?php foreach ($_SESSION['cart'] as $item => $weight): ?>
                    <li>
                        <?php echo "$item: $weight kg"; ?>
                        <form action="" method="POST" style="display:inline;">
                            <input type="hidden" name="item" value="<?php echo $item; ?>">
                            <button type="submit" name="removeItem">Remove</button>
                        </form>
                    </li>
                <?php endforeach; ?>
            </ul>
            <p>Total Weight: <?php echo $_SESSION['totalWeight']; ?> kg</p>
            <p>Total Amount: Php <?php echo number_format($_SESSION['total'], 2); ?></p>
        </div>

        <div class="payment">
            <h2>Payment</h2>
            <form action="" method="POST">
                <label for="paymentAmount">Enter Payment Amount (Php):</label>
                <input type="number" step="0.01" name="paymentAmount" required>
                <button type="submit" name="payment">Pay</button>
            </form>
            <p>Payment: Php <?php echo number_format($_SESSION['payment'], 2); ?></p>
            <p>Change: Php <?php echo number_format($_SESSION['change'], 2); ?></p>
        </div>

        <form action="" method="POST">
            <button type="submit" name="clearCart">Clear Cart</button>
        </form>
    </div>
</body>
</html>
