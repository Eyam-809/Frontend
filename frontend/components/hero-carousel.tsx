"use client"

import { useState, useEffect } from "react"
import { ChevronLeft, ChevronRight } from "lucide-react"
import { Button } from "@/components/ui/button"
import { motion, AnimatePresence } from "framer-motion"

const carouselItems = [
  {
    id: 1,
    buttonColor: "bg-yellow-400 hover:bg-yellow-500 text-white",
    image: "/dum.png",
  },
  {
    id: 2,
    buttonColor: "bg-emerald-400 hover:bg-emerald-500 text-black",
    image: "/mario.png",
  },
  {
    id: 3,
    buttonColor: "bg-pink-400 hover:bg-pink-500 text-white",
    image: "/poke.png",
  },
]

export default function HeroCarousel() {
  const [currentIndex, setCurrentIndex] = useState(0)
  const [direction, setDirection] = useState(0)

  const nextSlide = () => {
    setDirection(1)
    setCurrentIndex((prevIndex) => (prevIndex + 1) % carouselItems.length)
  }

  const prevSlide = () => {
    setDirection(-1)
    setCurrentIndex((prevIndex) => (prevIndex - 1 + carouselItems.length) % carouselItems.length)
  }

  useEffect(() => {
    const interval = setInterval(() => {
      nextSlide()
    }, 5000)
    return () => clearInterval(interval)
  }, [])

  const variants = {
    enter: (direction: number) => {
      return {
        x: direction > 0 ? 1000 : -1000,
        opacity: 0,
      }
    },
    center: {
      x: 0,
      opacity: 1,
    },
    exit: (direction: number) => {
      return {
        x: direction < 0 ? 1000 : -1000,
        opacity: 0,
      }
    },
  }

  const item = carouselItems[currentIndex]

  return (
    <div className="relative overflow-hidden rounded-xl my-6 shadow-xl">
      <div className="relative h-[300px] md:h-[400px] w-full">
        <AnimatePresence initial={false} custom={direction}>
          <motion.div
            key={currentIndex}
            custom={direction}
            variants={variants}
            initial="enter"
            animate="center"
            exit="exit"
            transition={{
              x: { type: "spring", stiffness: 300, damping: 30 },
              opacity: { duration: 0.2 },
            }}
            className="absolute inset-0 w-full h-full flex items-center"
          >
            <div className="container mx-auto px-4 md:px-10 flex flex-col md:flex-row items-center">
              <motion.img
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                transition={{ delay: 0.7 }}
                src={item.image}
                alt="Carousel image"
                className="absolute inset-0 w-full h-full object-cover"
              />
            </div>
          </motion.div>
        </AnimatePresence>
      </div>

      <Button
        onClick={prevSlide}
        variant="ghost"
        size="icon"
        className="absolute left-2 top-1/2 -translate-y-1/2 bg-white/30 hover:bg-white/50 backdrop-blur-sm rounded-full h-10 w-10 z-10"
      >
        <ChevronLeft className="h-6 w-6" />
        <span className="sr-only">Diapositiva anterior</span>
      </Button>

      <Button
        onClick={nextSlide}
        variant="ghost"
        size="icon"
        className="absolute right-2 top-1/2 -translate-y-1/2 bg-white/30 hover:bg-white/50 backdrop-blur-sm rounded-full h-10 w-10 z-10"
      >
        <ChevronRight className="h-6 w-6" />
        <span className="sr-only">Siguiente diapositiva</span>
      </Button>

      <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex space-x-2">
        {carouselItems.map((_, index) => (
          <button
            key={index}
            onClick={() => {
              setDirection(index > currentIndex ? 1 : -1)
              setCurrentIndex(index)
            }}
            className={`w-2 h-2 rounded-full transition-all ${index === currentIndex ? "w-6 bg-white" : "bg-white/50"}`}
            aria-label={`Go to slide ${index + 1}`}
          >
            <span className="sr-only">Ir a la diapositiva {index + 1}</span>
          </button>
        ))}
      </div>
    </div>
  )
}
