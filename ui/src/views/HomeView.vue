<script setup>
import { onMounted } from 'vue'
import Card from 'primevue/card'
import Divider from 'primevue/divider'
import Button from 'primevue/button'
import { usePaymentStore } from '@/stores/payment'

import { useRoute, useRouter } from 'vue-router'

const payment = usePaymentStore()
const route = useRoute()
const router = useRouter()

onMounted(() => {
  const payment_id = route.query.id
  if (!payment_id) {
    router.push('/error')
  } else {
    payment.get(payment_id)
  }
})
</script>

<template>
  <main>
    <Card>
      <template #header>
        <img src="@/assets/logo.png" alt="logo" class="logo" />
      </template>
      <template #title>Payment summary</template>
      <template #content>
        <div class="grid">
          <div>
            <h1>{{ payment.data.amount }}€</h1>
            <form
            <Button type="button" label="Pay now" icon="pi pi-check" />
          </div>
          <div>
            <Divider layout="vertical" />
          </div>

          <div v-if="payment.data.id">
            <p class="m-0"><b>ID</b>: {{ payment.data.id }}</p>
            <p class="m-0"><b>Owner</b>: {{ payment.data.owner }}</p>
            <p class="m-0"><b>Description</b>: {{ payment.data.description }}</p>
            <p class="m-0"><b>Created at</b>: {{ payment.data.created_at }}</p>
          </div>
        </div>
      </template>
    </Card>
  </main>
</template>
