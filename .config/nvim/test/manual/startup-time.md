# Startup time

**What changed:** removing the kitty theme call took a blocking subprocess out
of every launch. It cost 85ms when warm and 233ms cold, measured on your
machine, against a total startup of roughly 260ms.

## Steps

1. Just open nvim a few times and notice.

**You should feel:** it opens noticeably quicker than it used to.

2. If you want a number:
   ```sh
   nvim --headless --startuptime /tmp/st.log -c 'qa' && tail -1 /tmp/st.log
   ```

**You should see:** a line ending in `--- NVIM STARTED ---` with a total in
milliseconds at the front.

3. To see what is slowest, sort the log:
   ```sh
   sort -rn -k2 /tmp/st.log | head -15
   ```

## What it means

- [ ] Feels faster → **pass**
- [ ] Feels slower → something else regressed. Run the sort in step 3 and send
      me the top few lines.

## Note

There is no automated assertion on startup time. A hard threshold would be
flaky across machines and load, and a flaky test is worse than none.
