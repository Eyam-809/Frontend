"use client"

import { useEffect } from "react"
import Navbar from "@/components/navbar"
import HeroCarousel from "@/components/hero-carousel"
import CategorySection from "@/components/category-section"
import ProductGrid from "@/components/product-grid"
import PromoBanner from "@/components/promo-banner"
import Footer from "@/components/footer"
import CartSidebar from "@/components/cart-sidebar"
import FavoritesSidebar from "@/components/favorites-sidebar"
import CategoryPanel from "@/components/category-panel"
import CheckoutModal from "@/components/checkout-modal"
import { useApp } from "@/contexts/app-context"
import { products } from "@/data/products"

export default function Home() {
  const { dispatch } = useApp()

  useEffect(() => {
    dispatch({ type: "SET_PRODUCTS", payload: products })
  }, [dispatch])

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <CategoryPanel />
      <main className="container mx-auto px-4">
        <CategorySection />
        <HeroCarousel />
        <ProductGrid />
        {/*<PromoBanner /> */}
      </main>
      <Footer />
      <CartSidebar />
      <FavoritesSidebar />
      <CheckoutModal />
    </div>
  )
}
