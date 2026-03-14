//
//  String+Rule.swift
//  easyart
//
//  Created by Damon on 2025/3/7.
//

extension String {
    static func getRuleHtml(buyName: String, artistName: String, artworkName: String, payPrice: String, address: String) -> String {
        let content = """
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <div style=" word-wrap: break-word;
        white-space: pre-line;
        font-size: 12px;
        font-family: sans-serif, system-ui;
                display: flex;
                flex-direction: column;">
        <b>User Purchase Agreement
        
        </b>
        <p style="margin: 0;">In accordance with Japanese law, the Parties reach this agreement through friendly consultations on the sale and purchase of art under this agreement based on the principles of equality, voluntariness, fairness and reasonableness. The specific terms and conditions are as follows:

                <b>Party A:</b>
        EURO-ASIA CAPITAL JAPAN CO., LTD.
                        <b>Party B:</b>
        \(buyName)

        </p>

        <b>1. Artwork:</b>
        <p style="margin: 0;">Order Number: See order details
        Artist Name: \(artistName)
        Artwork Name: \(artworkName)

        </p>

        <b>2. Scope of Sale:</b>
        <p style="margin: 0;">At the agreed sale price, Party A agrees to sell the artwork to Party B, and Party B agrees to purchase the artwork from Party A. The scope of sale includes only the artwork itself.

        </p>

        <b>3. Sale Price:</b>
        <p style="margin: 0;">The sale price agreed upon by both parties is \(payPrice) USD, which includes applicable consumption tax.

        </p>

        <b>4. Payment and Invoice:</b>
        <p style="margin: 0;">Within fifteen(15) minutes after the signing of this agreement, Party B shall pay the sale price to Party A via credit card or Apple Pay (including mobile payment).
        If Party B requires Party A to issue an invoice, Party B shall provide the relevant invoicing information to Party A via email, specifying the order number. E-mail: info@easyart.cn. Upon receiving the full payment, invoicing information, and confirmation of order receipt from Party B, Party A shall issue a corresponding amount of consumption tax invoice within seven(7) working days.
        If Party B fails to make the payment on time, Party A will urge Party B to fulfill the debt. If Party B still fails to fulfill the debt after a reasonable period of time, this agreement will automatically terminate, the order will no longer be retained, and Party A has the right to sell the artwork to a third party without any liability.
        Party A's Receiving Account Information:
        Account Name: EURO-ASIA CAPITAL JAPAN CO., LTD.
        Bank:
        Sumitomo Mitsui Banking Corporation
        Hibiya Branch
        Account Number: (632)-9229352
        EURO-ASIA CAPITAL JAPAN CO., LTD.

        </p>

        <b>5. Artwork Rights:</b>
        <p style="margin: 0;">Party A guarantees that it has the right to sell the artwork listed in this agreement.

        </p>

        <b>6. Delivery and Acceptance of Artwork:</b>
        <p style="margin: 0;">Within fifteen(15) working days after receiving the full payment from Party B, Party A shall send the artwork to Party B by mail to the address provided by Party B (for the avoidance of doubt, the aforementioned "fifteen(15) working days" specifically refers to the period for Party A to complete the shipment and does not constitute a promise or guarantee of the artwork's delivery time; in addition, for certain artworks, the delivery time shall be as displayed on the details page).
        Party B's shipping information: \(address)
        Party B shall reasonably inspect the artwork upon delivery, and the inspection criteria shall be in accordance with the artwork overview listed in the appendix of this agreement, including the author, era, dimensions, material, preservation
        status, flaws, and remarks.
        If Party B has any objections to the received artwork, it may raise objections to Party A within seven(7) working days after receiving the artwork, and both parties shall handle the matter through friendly consultation; if the matter cannot be resolved through consultation, both parties agree that Party A shall hire a third-party institution with appropriate qualifications or experience to assist in verification (if the third-party institution supports Party A's opinion, it shall be deemed that the delivery and acceptance are completed, the verification fee shall be paid by Party B, and the transaction shall continue; if the third-party institution supports Party B's opinion, the verification fee shall be paid by Party A, and the transaction shall be terminated). If Party B fails to raise objections to Party A within seven(7) working days after receiving the artwork, it shall be deemed that Party B confirms that the received artwork is in accordance with the agreement.

        </p>

        <b>7. Termination of Transaction:</b>
        <p style="margin: 0;">Party B is only entitled to terminate this agreement before the delivery and acceptance of the artwork; once the delivery and acceptance are completed, it shall be deemed that Party B has confirmed the artwork. Regardless of the reason for the termination of the transaction, Party B shall return the artwork to Party A in its original condition at the earliest convenient time, and Party B is obligated to package and protect the artwork to the same standard as when Party A sent it. Only after Party A receives and confirms the acceptance of the artwork, Party A is obligated to refund the remaining amount to Party B after deducting the fees and liquidated damages (if applicable) that Party B should pay.

        </p>

        <b>8. Liability for Breach:</b>
        <p style="margin: 0;">If Party A breaches this agreement by providing false information regarding the ownership, authenticity, or defects of the artwork, resulting in the failure of delivery and acceptance and the termination of this agreement, Party A shall compensate Party B and bear the reasonable expenses incurred by Party B, but the compensation ratio shall not exceed 100% of the agreed sales price under any circumstances. However, this limitation does not apply if Party A breaches this agreement intentionally or with gross negligence. If Party B fails to pay the sales price and other expenses that Party B is responsible for in a timely and full amount, Party B shall pay Party A a penalty at the rate of 14.6% per annum of the unpaid amount.

        </p>

        <b>9. Dispute Resolution and Applicable Law:</b>
        <p style="margin: 0;">This agreement shall be governed by and construed in accordance with the laws of Japan. Any disputes arising from or related to this agreement, including any issues concerning the existence, validity, performance, or termination of this agreement, shall be resolved through amicable negotiations between the parties; if the negotiations fail, the Tokyo District Court shall be the exclusive court of first instance for the agreement. The losing party shall bear the reasonable expenses incurred by the prevailing party, including but not limited to attorney fees and litigation costs.

        </p>

        <b>10. Miscellaneous:</b>
        <p style="margin: 0;">Matters not covered in this agreement shall be subject to friendly negotiation by both parties and a supplementary agreement may be signed. The supplementary agreement has the same legal effect as this agreement. Any documents, replies and any other contact delivered by either party to the other party in accordance with the provisions of this Agreement shall be delivered in writing (including only personal delivery, written mail or email) to the other party's address or other contact information listed in this Agreement. If any party plans to change the contact information, it shall serve it through the service method agreed in this article. Without the prior written consent of either party, the other party shall not disclose or disclose the specific contents of all or part of the terms (including annexes) under this agreement to any third party (except for employees and professional consultants of one party), unless such information has become public through other legal channels or must be disclosed in accordance with legal provisions. Both parties confirm that the confidentiality obligation is not limited by the validity period of this agreement and will remain valid after the termination or cancellation of this agreement.

        </p>
        </div>
        """
        
        return content
    }
}
