import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { currentUserId: Number }

    connect() {
        this.applyStyles()
    }

    applyStyles() {
        const messageUserId = parseInt(this.element.dataset.userId)
        const isCurrentUser = messageUserId === this.currentUserIdValue

        const messageDirection = this.element.querySelector('[data-message-direction]')
        const messageBubble = this.element.querySelector('[data-message-bubble]')
        const timestamp = this.element.querySelector('[data-timestamp]')
        const senderName = this.element.querySelector('[data-sender-name]')

        // Clear any existing classes
        messageDirection.className = 'flex'
        messageBubble.className = 'rounded-2xl px-4 py-2 shadow-sm'
        if (timestamp) timestamp.className = 'text-xs mt-1 text-right'
        if (senderName) senderName.style.display = 'block'

        if (isCurrentUser) {
            // Current user's message - align right with blue background
            messageDirection.classList.add('justify-end')
            messageBubble.classList.add('bg-blue-600', 'text-white')
            timestamp.classList.add('text-blue-100')
            if (senderName) senderName.style.display = 'none'
        } else {
            // Other user's message - align left with white background
            messageDirection.classList.add('justify-start')
            messageBubble.classList.add('bg-white', 'text-gray-800', 'border', 'border-gray-200')
            timestamp.classList.add('text-gray-400')
        }
    }
}