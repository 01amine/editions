import { Ban } from "lucide-react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button"; 
import Link from "next/link";

export function Forbidden() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 text-center px-6">
      <motion.div
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.4 }}
        className="flex flex-col items-center"
      >
        <Ban className="w-24 h-24 text-red-500 mb-6" strokeWidth={1.5} />

        <h1 className="text-5xl font-bold text-gray-800 mb-4">403</h1>
        <h2 className="text-2xl font-semibold text-gray-700 mb-2">
          Forbidden Access
        </h2>

        <p className="text-gray-500 max-w-md mb-8">
          Sorry, you don’t have permission to access this page.  
          If you believe this is a mistake, please contact your administrator.
        </p>

        <div className="flex gap-4">
          <Link href="/dashboard">
            <Button className="rounded-2xl shadow-md">Go Home</Button>
          </Link>
          <Link href="/contact">
            <Button
              variant="outline"
              className="rounded-2xl border-gray-300 hover:bg-gray-100"
            >
              Contact Support
            </Button>
          </Link>
        </div>
      </motion.div>
    </div>
  );
}
