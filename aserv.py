import stripe
from flask import Flask, render_template_string, request, redirect, url_for

app = Flask(__name__)

# 设置Stripe API密钥
stripe.api_key = "your_stripe_secret_key"

# HTML内容
booking_html = """
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>按摩预约系统</title>
    <script src="https://js.stripe.com/v3/"></script>
</head>
<body>
    <h1>按摩预约系统</h1>
    <form action="/charge" method="post" id="payment-form">
        <div>
            <label for="email">电子邮箱：</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div>
            <label for="card-element">信用卡信息：</label>
            <div id="card-element"></div>
            <div id="card-errors" role="alert"></div>
        </div>
        <button type="submit">支付预约</button>
    </form>

    <script>
        var stripe = Stripe('your_stripe_publishable_key');
        var elements = stripe.elements();
        var card = elements.create('card');
        card.mount('#card-element');

        var form = document.getElementById('payment-form');
        form.addEventListener('submit', function(event) {
            event.preventDefault();

            stripe.createToken(card).then(function(result) {
                if (result.error) {
                    var errorElement = document.getElementById('card-errors');
                    errorElement.textContent = result.error.message;
                } else {
                    var hiddenInput = document.createElement('input');
                    hiddenInput.setAttribute('type', 'hidden');
                    hiddenInput.setAttribute('name', 'stripeToken');
                    hiddenInput.setAttribute('value', result.token.id);
                    form.appendChild(hiddenInput);
                    form.submit();
                }
            });
        });
    </script>
</body>
</html>
"""

success_html = """
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>支付成功</title>
</head>
<body>
    <h1>支付成功！</h1>
    <p>您已成功支付 ${{ amount }} 美元。</p>
    <p>感谢您的预约！</p>
</body>
</html>
"""

error_html = """
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>支付错误</title>
</head>
<body>
    <h1>支付错误</h1>
    <p>很抱歉，支付过程中出现了错误：{{ error }}</p>
    <p>请重新尝试或联系客户支持。</p>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(booking_html)

@app.route('/charge', methods=['POST'])
def charge():
    amount = 5000  # 金额（以分为单位）
    
    try:
        customer = stripe.Customer.create(
            email=request.form['email'],
            source=request.form['stripeToken']
        )
        
        charge = stripe.Charge.create(
            customer=customer.id,
            amount=amount,
            currency='usd',
            description='按摩预约'
        )
        
        return render_template_string(success_html, amount=amount/100)
    except stripe.error.CardError as e:
        return render_template_string(error_html, error=e.error.message)

if __name__ == '__main__':
    app.run(debug=True)
