# Play Store listing — Loan Calculator

Assets in this folder:

| File | Use in Play Console | Size |
|---|---|---|
| `play_store_icon_512.png` | Main store listing → App icon | 512 × 512 |
| `feature_graphic.png` | Main store listing → Feature graphic | 1024 × 500 |
| `screenshots/*.png` | Main store listing → Phone screenshots (captioned) | 1080 × 1920 |
| `screenshots-raw/*.png` | Un-captioned originals, if you prefer plain shots | 1080 × 2400 |

Upload 4–8 phone screenshots. Suggested order: `01_home`, `02_compare`,
`03_advanced`, `04_schedule`, `05_savings`, `06_tip`, `07_simple`.

---

## App name (30 char limit)

```
Loan Calculator
```

*Unchanged. 15/30 characters.* Renaming would not reduce Personal Loans
classification risk — the compliant permission set is what protects you — and
changing the name mid-appeal only adds a variable. If you later want the extra
keywords, `Loan Calculator & Amortization` (31) is one over; `Loan & Mortgage
Calculator` (27) fits.

---

## Short description (80 char limit)

```
Offline loan, mortgage & savings calculator with amortization schedules.
```

*71/80 characters.* Leads with "offline", which is the trust signal that most
directly answers the policy concern.

---

## Full description (4000 char limit)

```
Loan Calculator is a free, offline finance calculator. Work out loan payments,
build a full amortization schedule, compare different sets of loan terms side
by side, and handle everyday sums like tax, discount and tip — all on your
device.

IMPORTANT: This app is a calculator for estimates and education only. It does
not offer, broker, arrange, fund or facilitate loans of any kind. It does not
advertise or display real lender products, and it is not affiliated with any
lender. Every figure is an estimate calculated from numbers you type in
yourself, and is not financial advice.

PRIVACY BY DESIGN
◉ Requests no device permissions — not storage, contacts, location or SMS.
◉ Works completely offline. Nothing you enter leaves your phone.
◉ No account, no sign-up, no tracking, no advertising.

WHAT'S INSIDE

1. Simple Loan
• Switch between two modes: work out the monthly cost of a loan, or the maximum
  loan you could take for a payment you can afford.
• Enter amount, interest rate and term to see the payment, total interest and
  total repaid.

2. Advanced Loan
• Full mortgage breakdown: principal, interest, property tax, insurance and PMI.
• Enter your deposit as a cash amount or a percentage — tap the unit to switch.
• PMI is applied automatically while the deposit is under 20%.
• Month-by-month amortization schedule with yearly subtotals.
• Save calculations on this device and reopen them later.

3. Compare Loan
• Enter up to three sets of loan terms and see them side by side.
• Ranks the figures you entered by total cost — interest plus up-front fees —
  so a low rate with a big arrangement fee doesn't look cheaper than it is.
• Shows which of your entries costs least overall, which has the lowest monthly
  payment, and the difference between them.

4. Savings Calculator
• Project growth from a starting amount plus regular contributions.
• Choose weekly, bi-weekly, monthly, quarterly or annual contributions.
• See the final balance split into what you contributed and what you earned.

5. Sales Tax Calculator
• Tax amount and total price from a price and a rate.

6. Discount Calculator
• Final price and how much you save, with optional tax.

7. Tip Calculator
• Tip, tax and total, split evenly across any number of people.

EXPORT AND SHARE
◉ Export any Advanced Loan result as a PDF and share or print it.
◉ Share any result card as an image, straight to the app of your choice.
◉ Because sharing goes through Android's share sheet, the app never needs
  storage permission.

BUILT FOR MODERN ANDROID
◉ Material 3 design with full light and dark theme support.
◉ Results update live as you type.
◉ Free, with no in-app purchases.

Have a question or a feature request? Send feedback from inside the app.
```

*Roughly 2,500 characters — comfortably inside the 4,000 limit.*

---

## ⚠️ Policy audit of this copy

Three things in the first draft were changed because they carried real risk.

### 1. "loan offers" → "sets of loan terms"  *(the important one)*

The draft said *"compare competing loan offers"* and *"Put up to three offers
side by side."*

**Why that was risky:** "loan offers" is the vocabulary of lead generation and
loan brokering. Google's Personal Loans policy covers apps that *facilitate*
loans, and comparison/marketplace apps get pulled into that bucket. You have
already been misclassified once as a personal loans product — feeding the
reviewer (and the classifier) the exact phrase that describes a broker is the
last thing this listing should do.

The feature compares numbers **the user types in**. The copy now says so
explicitly, in both the intro and the feature list.

### 2. "Small, fast, and free" → "Free, with no in-app purchases"

The universal APK is ~54 MB. "Small" is simply not true, and inaccurate factual
claims in metadata are a (minor) Store Listing policy issue. "No in-app
purchases" is true and verifiable — the billing permission and the
`in_app_purchase` dependency are both gone from the bundle.

### 3. "we read everything" → removed

An unverifiable promise about your own conduct. Harmless, but there is no
reason to make a claim you could be held to.

---

## 🚨 Claims you must keep true

Two lines in this description are **verifiable factual claims**, not marketing:

> ◉ Requests no device permissions — not storage, contacts, location or SMS.
> ◉ No account, no sign-up, no tracking, no advertising.

They are true of the current build. **The moment you re-add AdMob they both
become false** — the ads SDK reintroduces `com.google.android.gms.permission.AD_ID`
and three `ACCESS_ADSERVICES_*` permissions, and "no advertising" stops being
accurate.

A false permissions claim in a listing, on an app already sanctioned under
Personal Loans policy, is a much worse position than simply having ads. So:
**if you ever re-enable ads, edit this description in the same release.** Don't
leave it for later.

---

## Privacy policy — required, and not yet handled

Google Play requires a privacy policy URL in Play Console → App content, for
**every** app, including ones that collect nothing. A missing or dead link is a
common rejection cause and would waste an appeal cycle.

Yours must be a publicly reachable URL (GitHub Pages or a Google Site is fine)
and should state, at minimum:

- The app collects, stores and transmits no personal data.
- All calculations and saved results stay on the user's device.
- No analytics, no advertising identifiers, no third-party SDKs.
- Contact address for privacy questions.
- Date of last update.

Ask and I'll write the policy text and a ready-to-publish HTML page.

---

## Financial features declaration — do not skip this

Play Console → **App content → Financial features**.

Declare that the app does **not** provide personal loans and is not a lender or
loan aggregator. This is a formal, on-the-record statement that directly
contradicts the classification that got the app removed. It carries more weight
with a reviewer than any sentence in the description, and leaving it blank or
mis-answered is itself a policy violation.

---

## Data safety form

With ads removed, the app collects and shares nothing. Answer:

- Does your app collect or share any of the required user data types? → **No**
- Is all of the user data collected by your app encrypted in transit? → N/A
- Do you provide a way for users to request that their data is deleted? → N/A

Make sure any previously declared advertising ID collection is cleared — that
declaration was for the AdMob SDK, which is no longer in the bundle. A stale
"collects advertising ID" declaration against a bundle that contains no ads SDK
is a mismatch a reviewer can see.

---

## Content rating

Re-take the questionnaire if it asks about ads. The app now contains no
advertising and no user-generated content.

---

## What changed from your original listing

**Removed — this line was the dangerous one:**

> ◉ Save advanced loan results as pdf.

The app no longer writes files to device storage; that capability is exactly
what triggered the Personal Loans removal. Advertising it while claiming to
have removed it is the worst possible mismatch for a reviewer to find. The
export line now says share/print, which is what the app actually does.

**Added:**

- An explicit non-lender disclaimer. Your app was misclassified as a personal
  loans product because of its name, not its behaviour. This paragraph is the
  single highest-value change in the whole listing.
- A permissions/privacy block that is literally true and independently
  verifiable by the reviewer.
- Compare Loan, which didn't exist before.
- Simple Loan's max-loan mode, which was never documented.

**Fixed:**

- "Loan Calculate allows you to…" → "Loan Calculator is…"
- "principle amount" / "given principle" → **principal** (the original was the
  wrong word in two places)
- Dropped "beautiful user interface" — Play's metadata guidance discourages
  self-promotional filler, and it adds nothing.
