/**
 * Blocks bash tool calls matching BANNED before they execute.
 * Guardrail against the model doing something dumb, not a security boundary:
 * regex over a shell string is bypassable (`r''m`, `$(echo rm)`).
 */
import { isToolCallEventType, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Banned: rm -r / rm -f (any flag combo), sudo, git push
const BANNED = [/\brm\s+-[a-z]*[rf]/, /\bsudo\b/, /\bgit\s+push\b/];

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", (event) => {
		if (!isToolCallEventType("bash", event)) return;
		const hit = BANNED.find((re) => re.test(event.input.command));
		if (hit) return { block: true, reason: `Blocked by policy: ${hit}` };
	});
}
