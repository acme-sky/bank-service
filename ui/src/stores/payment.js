import { defineStore } from 'pinia'

export const usePaymentStore = defineStore('payment', {
  state: () => ({ data: {}, inloading: false }),
  actions: {
    async get(id) {
      await fetch(`${import.meta.env.VITE_BACKEND_URL}/payments/${id}/`).then(async (response) => {
        this.data = await response.json()
      })
      return this.data
    },
    async pay(id) {
      this.inloading = true
      let result = 400

      await fetch(`${import.meta.env.VITE_BACKEND_URL}/payments/${id}/pay/`, { method: 'POST' })
        .then(async (response) => {
          result = response.status
        })
        .finally(() => {
          this.inloading = false
        })

      return result
    }
  }
})
