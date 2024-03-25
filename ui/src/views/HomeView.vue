<script setup>
import { onMounted } from 'vue'
import { ref } from 'vue'
import Card from 'primevue/card'
import Divider from 'primevue/divider'
import Button from 'primevue/button'
import InputGroup from 'primevue/inputgroup'
import InputText from 'primevue/inputtext'
import InputMask from 'primevue/inputmask'
import Message from 'primevue/message'

import { usePaymentStore } from '@/stores/payment'
import { useRoute, useRouter } from 'vue-router'

const payment = usePaymentStore()
const route = useRoute()
const router = useRouter()

const form = ref({})
const errors = ref({})
const success_alert = ref(false)
const error_alert = ref(false)

onMounted(() => {
  const payment_id = route.query.id
  if (!payment_id) {
    router.push('/error')
  } else {
    payment.get(payment_id)
  }
})

function save(event) {
  event.preventDefault()
  let rc = 0
  for (const key of ['holder', 'card', 'due', 'cvc']) {
    errors.value[key] = !form.value[key]
    rc += errors.value[key]
  }

  if (!rc) {
    payment.pay(route.query.id).then((response) => {
      if (response == 200) {
        const callback = route.query.callback ?? '/success'
        success_alert.value = true
        error_alert.value = false
        setTimeout(() => {
          window.location.href = callback
        }, 2000)
      } else {
        success_alert.value = false
        error_alert.value = true
      }
    })
  }
}
</script>

<template>
  <main>
    <Card>
      <template #header>
        <img src="@/assets/logo.png" alt="logo" class="logo" />
        <div class="msg">
          <Message severity="success" v-if="success_alert">
            Success! You will be redirect soon.
          </Message>
          <Message severity="error" v-if="error_alert">Error! Try again.</Message>
        </div>
      </template>
      <template #title>Payment summary</template>
      <template #content>
        <div class="grid">
          <div>
            <h1 class="amount">{{ payment.data.amount }}€</h1>
            <form @submit="save">
              <InputGroup>
                <div class="input-g">
                  <label for="card-holder">Card holder</label>
                  <InputText
                    :class="{ error: errors.holder }"
                    id="card-holder"
                    placeholder="John Doe"
                    v-model="form.holder"
                  />
                  <span class="error" v-if="errors.holder">You msut fill this field.</span>
                </div>
              </InputGroup>
              <InputGroup>
                <div class="input-g">
                  <label for="card-number">Card number</label>
                  <InputMask
                    :class="{ error: errors.card }"
                    id="card-number"
                    placeholder="9999-9999-9999-9999"
                    mask="9999-9999-9999-9999"
                    v-model="form.card"
                  />
                  <span class="error" v-if="errors.card">You msut fill this field.</span>
                </div>
              </InputGroup>
              <InputGroup>
                <div class="input-g">
                  <label for="card-due">Card due</label>
                  <InputMask
                    :class="{ error: errors.due }"
                    id="card-number"
                    placeholder="01/25"
                    mask="99/99"
                    v-model="form.due"
                  />
                  <span class="error" v-if="errors.due">You msut fill this field.</span>
                </div>
              </InputGroup>
              <InputGroup>
                <div class="input-g">
                  <label for="card-due">CVC</label>
                  <InputMask
                    :class="{ error: errors.cvc }"
                    id="card-number"
                    placeholder="555"
                    mask="999"
                    v-model="form.cvc"
                  />
                  <span class="error" v-if="errors.cvc">You msut fill this field.</span>
                </div>
              </InputGroup>
              <Button
                type="click"
                @click="save"
                :label="'Pay now ' + payment.data.amount + '€'"
                id="pay-now"
                icon="pi pi-check"
                :loading="payment.inloading"
              />
            </form>
          </div>
          <div>
            <Divider layout="vertical" />
          </div>

          <div v-if="payment.data.id">
            <h3>{{ payment.data.description }}</h3>
            <Divider />
            <p class="m-0"><b>ID</b>: {{ payment.data.id }}</p>
            <p class="m-0"><b>Owner</b>: {{ payment.data.owner }}</p>
            <p class="m-0"><b>Created at</b>: {{ payment.data.created_at }}</p>
          </div>
        </div>
      </template>
    </Card>
  </main>
</template>
