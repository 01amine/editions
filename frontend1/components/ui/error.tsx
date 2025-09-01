import { AlertTriangle, RefreshCw, AlertCircle, XCircle } from "lucide-react"
import { Button } from "./button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "./card"
import { Alert, AlertDescription } from "./alert"

interface ErrorProps {
  title?: string
  message?: string
  error?: Error | string | null
  onRetry?: () => void
  variant?: "default" | "destructive" | "warning"
  className?: string
}

export function Error({ 
  title = "Une erreur s'est produite", 
  message = "Impossible de charger les données. Veuillez réessayer.",
  error,
  onRetry,
  variant = "default",
  className 
}: ErrorProps) {
  const getIcon = () => {
    switch (variant) {
      case "destructive":
        return <XCircle className="h-5 w-5" />
      case "warning":
        return <AlertTriangle className="h-5 w-5" />
      default:
        return <AlertCircle className="h-5 w-5" />
    }
  }

  const getVariantClasses = () => {
    switch (variant) {
      case "destructive":
        return "border-destructive text-destructive"
      case "warning":
        return "border-yellow-500 text-yellow-700"
      default:
        return "border-muted-foreground text-muted-foreground"
    }
  }

  return (
    <Card className={className}>
      <CardHeader className="text-center">
        <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-muted">
          {getIcon()}
        </div>
        <CardTitle className="text-lg">{title}</CardTitle>
        <CardDescription>{message}</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {error && (
          <Alert className={getVariantClasses()}>
            <AlertDescription className="text-sm">
              {typeof error === "string" ? error : error.message}
            </AlertDescription>
          </Alert>
        )}
        
        {onRetry && (
          <div className="flex justify-center">
            <Button onClick={onRetry} variant="outline" className="gap-2">
              <RefreshCw className="h-4 w-4" />
              Réessayer
            </Button>
          </div>
        )}
      </CardContent>
    </Card>
  )
}

// Inline error for forms
export function InlineError({ message, className }: { message: string; className?: string }) {
  return (
    <div className={`flex items-center gap-2 text-sm text-destructive ${className}`}>
      <XCircle className="h-4 w-4" />
      <span>{message}</span>
    </div>
  )
}

// Error state for data tables/grids
export function DataError({ 
  error, 
  onRetry, 
  title = "Erreur de chargement",
  message = "Impossible de charger les données"
}: {
  error: Error | string | null
  onRetry?: () => void
  title?: string
  message?: string
}) {
  return (
    <div className="flex flex-col items-center justify-center p-8 text-center">
      <div className="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-muted">
        <XCircle className="h-8 w-8 text-destructive" />
      </div>
      <h3 className="mb-2 text-lg font-semibold">{title}</h3>
      <p className="mb-4 text-sm text-muted-foreground">{message}</p>
      {error && (
        <p className="mb-4 text-xs text-muted-foreground max-w-md">
          {typeof error === "string" ? error : error.message}
        </p>
      )}
      {onRetry && (
        <Button onClick={onRetry} variant="outline" className="gap-2">
          <RefreshCw className="h-4 w-4" />
          Réessayer
        </Button>
      )}
    </div>
  )
}

// Error boundary fallback
export function ErrorFallback({ 
  error, 
  resetErrorBoundary 
}: { 
  error: Error
  resetErrorBoundary: () => void 
}) {
  return (
    <div className="flex min-h-screen items-center justify-center p-4">
      <Error
        title="Quelque chose s'est mal passé"
        message="Une erreur inattendue s'est produite. Veuillez rafraîchir la page."
        error={error}
        onRetry={resetErrorBoundary}
        variant="destructive"
      />
    </div>
  )
}
