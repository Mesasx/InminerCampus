export type PaymentNotificationResult = 'sent' | 'already_sent'

export async function runPaymentNotification<Purchase>(
  purchaseId: string,
  dependencies: {
    claim: (purchaseId: string) => Promise<boolean>
    load: (purchaseId: string) => Promise<Purchase>
    send: (purchase: Purchase) => Promise<string>
    complete: (result: {
      purchaseId: string
      success: boolean
      messageId: string
      error: string
    }) => Promise<void>
  },
): Promise<PaymentNotificationResult> {
  const claimed = await dependencies.claim(purchaseId)
  if (!claimed) return 'already_sent'

  try {
    const purchase = await dependencies.load(purchaseId)
    const messageId = await dependencies.send(purchase)
    await dependencies.complete({
      purchaseId,
      success: true,
      messageId,
      error: '',
    })
    return 'sent'
  } catch (notificationError) {
    const safeMessage =
      notificationError instanceof Error
        ? notificationError.message
        : 'Unknown notification error'
    await dependencies.complete({
      purchaseId,
      success: false,
      messageId: '',
      error: safeMessage,
    })
    throw notificationError
  }
}
