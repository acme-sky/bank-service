import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import ErrorView from '@/views/Error.vue'
import ExpiredView from '@/views/Expired.vue'
import SuccessView from '@/views/Success.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/error',
      name: 'error',
      component: ErrorView
    },
    {
      path: '/expired',
      name: 'expired',
      component: ExpiredView
    },
    {
      path: '/success',
      name: 'success',
      component: SuccessView
    }
  ]
})

export default router
