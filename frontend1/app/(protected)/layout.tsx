"use client"
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { get_me } from "@/lib/api/auth";

export default function ProtectedLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    get_me().catch(() => router.push("/")).finally(() => setLoading(false));
  }, []);

  if (loading) return <div>Loading...</div>;
  return <>{children}</>;
}
