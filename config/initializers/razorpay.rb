# Razorpay.setup('key_id', 'key_secret')
Razorpay.setup(ENV.fetch('RZ_KEY_ID'), ENV.fetch('RZ_KEY_SECRET'))
Razorpay.headers = {"application_name" => "smart_exams_app"}