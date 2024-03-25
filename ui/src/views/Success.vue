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
          <Message severity="success"> Payment done! Now you're less rich :-( </Message>
        </div>
      </template>
    </Card>
  </main>
</template>
