// A counselor's external mock exam is a separate plan-box kind, not an exam
// designed inside Nova and not the existing simulation_exam activity selector.
// The existing plan schema requires a subject; encode the provider in that
// subject so published plans and print views retain it without a second source.
export const externalSimulationActivity = "external_simulation_exam";
export const externalSimulationTitle = "آزمون شبیه‌ساز";
export const externalSimulationPrefix = `${externalSimulationTitle} · `;
export const simulationProviders = ["ماز", "قلم‌چی (کانون)", "گزینه دو", "گاج", "سنجش", "خیلی سبز"] as const;

export function simulationSubject(provider: string): string {
  const name = provider.trim();
  return name ? `${externalSimulationPrefix}${name}` : externalSimulationTitle;
}

export function simulationProviderDraft(subject: string): string {
  return subject.startsWith(externalSimulationPrefix) ? subject.slice(externalSimulationPrefix.length) : "";
}

export function simulationProvider(subject: string): string | null {
  if (!subject.startsWith(externalSimulationPrefix)) return null;
  const provider = simulationProviderDraft(subject);
  return provider === provider.trim() && provider.length >= 2 && provider.length <= 60 && !/[\u0000-\u001f\u007f]/u.test(provider)
    ? provider : null;
}
