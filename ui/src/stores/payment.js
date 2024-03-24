import { defineStore } from 'pinia'

export const usePaymentStore = defineStore('payment', {
  state: () => ({ data: {} }),
  actions: {
    get(id) {
      fetch(`http://localhost:8080/payments/${id}/`).then(async (response) => {
        this.data = await response.json()
      })
    }
  }
})
