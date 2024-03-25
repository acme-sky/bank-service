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
            You are here because an error. The link could be not valid.
          </Message>
        </div>
      </template>
    </Card>
  </main>
</template>
