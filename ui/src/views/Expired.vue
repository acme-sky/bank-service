<script setup>
import Message from 'primevue/message'
import Card from 'primevue/card'
</script>

<template>
  <main>
    <Card>
      <template #header>
        <img src="@/assets/logo.png" alt="logo" class="logo" />
        <div class="msg">
          <Message severity="error">
            The link you used is expired because that payment is already paid! You're so rich, dude.
          </Message>
        </div>
      </template>
    </Card>
  </main>
</template>
