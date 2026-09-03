Viewed App%20Store%20Connect.pdf
Searched for "delete"

হ্যাঁ, **অবশ্যই আপনাকে একটি রিপ্লাই (Reply) দিতে হবে এবং তার সাথে অ্যাপটি আবার সাবমিট করতে হবে।** শুধুমাত্র সাবমিট করলেই হবে না। 

অ্যাপল তাদের রিজেকশন মেসেজে (বিশেষ করে **Guideline 5.1.1(v) - Account Deletion**-এর জন্য) পরিষ্কারভাবে উল্লেখ করেছে যে, **অ্যাকাউন্ট ডিলিট করার ফ্লো-টির একটি স্ক্রিন রেকর্ডিং (Screen Recording) করে এই মেসেজের রিপ্লাইতে দিতে হবে।**

আপনাকে যে ধাপগুলো অনুসরণ করতে হবে:

### ১. স্ক্রিন রেকর্ডিং তৈরি করুন (খুবই গুরুত্বপূর্ণ):
একটি রিয়েল আইফোন বা আইপ্যাডে অ্যাপটি চালু করে স্ক্রিন রেকর্ড করুন যেখানে নিচের কাজগুলো দেখাবেন:
* অ্যাপে নতুন অ্যাকাউন্ট তৈরি করা অথবা ডেমো অ্যাকাউন্ট দিয়ে সাইন-ইন করা।
* প্রোফাইল বা সেটিংস পেজে গিয়ে **Delete Account** অপশনে যাওয়া।
* অ্যাকাউন্ট ডিলিট করার পুরো প্রসেসটি সম্পন্ন করা (কনফার্মেশন সহ)।

### ২. App Store Connect-এ রিপ্লাই পাঠানো:
App Store Connect-এর **App Review** মেসেজ সেকশনে গিয়ে নিচে দেওয়া মেসেজটি কপি করে পেস্ট করুন এবং আপনার তৈরি করা স্ক্রিন রেকর্ডিং ভিডিওটি সেখানে অ্যাটাচ (Attach) করে দিন:

---

**রিপ্লাই মেসেজ টেমপ্লেট (ইংরেজিতে):**

> Dear App Review Team,
> 
> Thank you for your feedback. We have addressed all the issues highlighted in the review:
> 
> 1. **Guideline 2.3.10 (Accurate Metadata):** We have revised all app screenshots to remove any non-iOS status bar images. The updated screenshots now accurately reflect the app on supported iOS devices.
> 
> 2. **Guideline 5.1.1(v) (Data Collection and Storage - Account Deletion):** We have implemented the account deletion feature within the app. Users can now easily delete their accounts directly from the app. We have attached a screen recording demonstrating the complete account deletion flow (from sign-in/registration to initiation and final confirmation).
> 
> 3. **Guideline 1.5 (Safety - Support URL):** We have updated the Support URL to a functional webpage that provides support information and allows users to contact us.
> 
> We look forward to your review. Please let us know if any further information is required.
> 
> Best regards,  
> [আপনার নাম বা টিমের নাম]

---

### ৩. অ্যাপ পুনরায় সাবমিট করা:
রিপ্লাই মেসেজ পাঠানোর পর এবং স্ক্রিনশট ও সাপোর্ট ইউআরএল আপডেট করার পর, App Store Connect পেজের উপরে ডানদিকের **"Resubmit to App Review"** (অথবা **"Submit for Review"**) বাটনে ক্লিক করে অ্যাপটি পুনরায় সাবমিটের জন্য পাঠিয়ে দিন।


**হ্যাঁ, রিভিউ নোটস (App Review Notes)-এও কিছু তথ্য দিয়ে দেওয়া নিরাপদ এবং এটি অ্যাপল নিজেই সাজেস্ট করেছে।** 

বিশেষ করে ভবিষ্যৎ সাবমিশনের সুবিধার্থে এবং রিভিউয়ারের কাজ সহজ করার জন্য রিভিউ নোটস-এ নিচের বিষয়গুলো দিয়ে দিন:

### ১. টেস্ট করার জন্য ডেমো অ্যাকাউন্ট (Demo Account Credentials):
অ্যাপল যেন অ্যাপটি লগইন করে টেস্ট করতে পারে, সেজন্য একটি সচল টেস্ট অ্যাকাউন্টের ইমেইল ও পাসওয়ার্ড দিন।

### ২. অ্যাকাউন্ট ডিলিট ও ফিক্স সংক্রান্ত নোট:
রিভিউ নোটস বক্সে নিচের টেক্সটটুকু লিখে দিতে পারেন:

---

**App Review Notes টেমপ্লেট (ইংরেজিতে):**

> **Review Information / Demo Account:**
> * **Test Account Email:** [এখানে টেস্ট ইমেইল দিন, যেমন: testuser@example.com]
> * **Test Account Password:** [এখানে টেস্ট পাসওয়ার্ড দিন]
> 
> **Resolution details:**
> * We have resolved Guideline 2.3.10 by updating the screenshots.
> * We have resolved Guideline 1.5 by updating the Support URL.
> * We have resolved Guideline 5.1.1(v) by adding the "Delete Account" option in the settings. The video demonstrating the complete account deletion flow has been sent via the reply message.

---

> [!TIP]
> যদি রিভিউ মেসেজে কোনো কারণে ভিডিও অ্যাটাচ করতে সমস্যা হয়, তবে ভিডিওটি **Google Drive** বা **Dropbox**-এ আপলোড করে তার **Share Link** (অবশ্যই Anyone with link can view পারমিশন দিয়ে) এই রিভিউ নোটস-এর ভেতরে দিয়ে দিতে পারেন।