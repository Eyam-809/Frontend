"use client"

import { useRouter } from "next/navigation"
import { useApp } from "../../contexts/app-context"
import { LogOut } from "lucide-react"

interface LogoutButtonProps {
  className?: string
  iconOnly?: boolean
}

const LogoutButton = ({ className, iconOnly = false }: LogoutButtonProps) => {
  const { dispatch } = useApp()
  const router = useRouter()

  const handleLogout = () => {
    localStorage.removeItem("token")
    localStorage.removeItem("user_id")
    localStorage.removeItem("plan_id")

    dispatch({ type: "CLEAR_USER_SESSION" })

    router.push("/")
  }

  if (iconOnly) {
    return (
      <button
        onClick={handleLogout}
        className={`text-white hover:text-yellow-300 transition-colors ${className}`}
        aria-label="Cerrar sesión"
      >
        <LogOut className="h-5 w-5" />
      </button>
    )
  }

  return (
    <button
      onClick={handleLogout}
      className={`px-4 py-2 rounded bg-red-500 hover:bg-red-600 text-white font-semibold ${className}`}
    >
      Cerrar sesión
    </button>
  )
}

export default LogoutButton
