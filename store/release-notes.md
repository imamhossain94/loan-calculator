# Play Console → "What's new in this version"

500 character limit per language. Paste one of the blocks below.

## Recommended — 4 lines (279 chars)

```
• NEW Compare Loan — three sets of terms side by side, ranked by total cost including fees.
• Completely redesigned, with dark mode.
• All ads removed. No permissions required — works fully offline.
• Saving results now uses Android's share sheet instead of the Downloads folder.
```

## Tighter — 3 lines (234 chars)

```
• NEW Compare Loan — three sets of terms side by side, ranked by total cost including fees.
• Completely redesigned with dark mode, and every ad removed.
• No permissions required. Saving now uses Android's share sheet, not Downloads.
```

## Longer version (472 chars)

Kept in case you want the full detail.

```
A full redesign, plus a new way to compare loans.

• NEW Compare Loan — put up to three sets of terms side by side, ranked by total cost including up-front fees.
• Rebuilt in Material 3, with full dark mode.
• All ads removed.
• The app now requests no device permissions at all and works entirely offline.
• Export results as a PDF to share or print.
• Live results as you type.

Saved images and PDFs now go through Android's share sheet instead of the Downloads folder.
```

---

## Why the last line is there

The old version wrote PNGs and PDFs into `/storage/emulated/0/Download/LoanCalculator/`
and listed them in a Gallery screen. Both are gone — that storage access is
precisely what triggered the Personal Loans removal.

Users who relied on it will notice, so the note says where the files went. Do
not omit it: an unexplained missing feature generates one-star reviews, and
"files vanished after update" is a much worse complaint than "the save button
became a share button."

Files saved by the previous version are still on the device in that folder.
The app can no longer list them, but the system Files app can.

---

## What NOT to write here

- Don't mention the policy violation, the removal, or the appeal. Release notes
  are read by users, not just the reviewer, and it invites questions you gain
  nothing from answering.
- Don't use the phrase "loan offers" — same lead-generation vocabulary problem
  flagged in `listing.md`. "Sets of terms" is the safe wording.
- Don't claim "no permissions" here *and* forget to update it if you ever
  re-enable ads. See the warning box in `listing.md`.
