"use client";
import { useState } from "react";
import { createClient } from "@/lib/supabase/client";
const phrase = "حذف حساب من";
export function DeleteAccount() {
  const [value, setValue] = useState("");
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");
  async function remove() {
    if (value.trim() !== phrase) {
      setMessage(`برای تأیید عبارت «${phrase}» را دقیق وارد کن.`);
      return;
    }
    if (
      !window.confirm(
        "حساب و اطلاعات وابسته به‌صورت دائمی حذف می‌شود. ادامه می‌دهی؟",
      )
    )
      return;
    setLoading(true);
    setMessage("");
    const client = createClient();
    const { error } = await client.functions.invoke("delete-account", {
      body: { confirmation: "DELETE_MY_ACCOUNT" },
    });
    if (error) {
      setMessage(
        "حذف حساب انجام نشد. دوباره تلاش کن یا با پشتیبانی تماس بگیر.",
      );
      setLoading(false);
      return;
    }
    await client.auth.signOut();
    window.location.assign("/?account=deleted");
  }
  return (
    <div className="account-delete-box">
      <label htmlFor="delete-confirmation">
        برای تأیید، عبارت <strong>{phrase}</strong> را وارد کن.
      </label>
      <input
        id="delete-confirmation"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        autoComplete="off"
      />
      <button
        type="button"
        onClick={remove}
        disabled={loading || value.trim() !== phrase}
      >
        {loading ? "در حال حذف..." : "حذف دائمی حساب"}
      </button>
      {message && <p role="alert">{message}</p>}
    </div>
  );
}
