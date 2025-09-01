"use client"
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { get_me } from "@/lib/api/auth";
import { Loading } from "@/components/ui/loading";

export default function ProtectedLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    get_me().catch(() => router.push("/")).finally(() => setLoading(false));
  }, []);

  if (loading) return <Loading type="spinner" className="h-screen" />;
  return <>{children}</>;
}
