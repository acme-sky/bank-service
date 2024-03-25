import { defineStore } from 'pinia'

export const usePaymentStore = defineStore('payment', {
  state: () => ({ data: {}, inloading: false }),
  actions: {
    get(id) {
      fetch(`http://localhost:8080/payments/${id}/`).then(async (response) => {
        this.data = await response.json()
      })
    },
    async pay(id) {
      this.inloading = true
      let result = 400

      await fetch(`http://localhost:8080/payments/${id}/pay/`, { method: 'POST' })
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
