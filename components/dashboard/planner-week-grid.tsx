"use client";

import { useEffect, useRef, useState, type DragEvent, type KeyboardEvent } from "react";
import { addDays, formatPersianWeekday, parseIsoDate, persianMonthNames, persianNumber, persianParts } from "@/lib/persian-date";
import { clonePlannerGrid, copyPlannerBlock, movePlannerBlock, summarizePlannerGrid, type GridPosition, type PlannerBlock, type PlannerGrid } from "@/lib/planner-grid";
import styles from "./planner-week-grid.module.css";

type Props = {
  weekStart: string;
  grid: PlannerGrid;
  lockedDays: boolean[];
  onChange: (grid: PlannerGrid) => void;
  onEdit: (block: PlannerBlock) => void;
  onAdd: (day: number) => void;
};

function subjectColor(subject: string) {
  if (subject.includes("زیست")) return "#2fa675";
  if (subject.includes("شیمی")) return "#dd6660";
  if (subject.includes("فیزیک")) return "#249eb7";
  if (subject.includes("ریاضی") || subject.includes("حسابان")) return "#5985d0";
  if (subject.includes("زبان")) return "#ca77a4";
  if (subject.includes("دینی") || subject.includes("ادبیات") || subject.includes("فارسی")) return "#daa32c";
  if (subject.includes("عربی")) return "#269d98";
  if (subject.includes("آزمون")) return "#9673be";
  return "#7692ae";
}
function displayMinutes(minutes: number) {
  const hours = Math.floor(minutes / 60), remainder = minutes % 60;
  return hours ? `${persianNumber.format(hours)}:${String(remainder).padStart(2, "0").replace(/\d/g, digit => "۰۱۲۳۴۵۶۷۸۹"[Number(digit)])} ساعت` : `${persianNumber.format(remainder)} دقیقه`;
}
function newClientKey() {
  return `copy-${Array.from(crypto.getRandomValues(new Uint32Array(4)), n => n.toString(16).padStart(8, "0")).join("")}`;
}
function locate(grid: PlannerGrid, key: string): GridPosition | null {
  for (let day = 0; day < 7; day++) {
    const index = grid[day].findIndex(item => item?.key === key);
    if (index !== -1) return {day,index};
  }
  return null;
}

/** A controlled editor surface; persistence and authorization remain with its caller. */
export function PlannerWeekGrid({weekStart, grid, lockedDays, onChange, onEdit, onAdd}: Props) {
  const [selected, setSelected] = useState<string | null>(null);
  const [menu, setMenu] = useState<string | null>(null);
  const [clipboard, setClipboard] = useState<PlannerBlock | null>(null);
  const [dayClipboard, setDayClipboard] = useState<PlannerBlock[] | null>(null);
  const [message, setMessage] = useState("");
  const [canUndo, setCanUndo] = useState(false);
  const history = useRef<PlannerGrid[]>([]);
  const expected = useRef(JSON.stringify(grid));
  const dragKey = useRef<string | null>(null);
  const focusKey = useRef<string | null>(null);
  const buttons = useRef(new Map<string, HTMLButtonElement>());
  const signature = JSON.stringify(grid);
  useEffect(() => {
    if (signature !== expected.current) { history.current = []; setCanUndo(false); expected.current = signature; }
    if (focusKey.current) { buttons.current.get(focusKey.current)?.focus(); focusKey.current = null; }
  }, [signature]);
  if (grid.length !== 7 || lockedDays.length !== 7) throw new Error("Seven planner days are required");
  const summary = summarizePlannerGrid(grid);
  const commit = (next: PlannerGrid, focus?: string) => {
    history.current = [...history.current.slice(-49), clonePlannerGrid(grid)];
    setCanUndo(true); expected.current = JSON.stringify(next); focusKey.current = focus ?? null;
    onChange(next); setMenu(null); setMessage("");
  };
  const undo = () => {
    const previous = history.current.pop(); if (!previous) return;
    setCanUndo(history.current.length > 0); expected.current = JSON.stringify(previous); onChange(previous); setMenu(null); setMessage("آخرین تغییر برگردانده شد.");
  };
  const protect = (block: PlannerBlock, day: number) => Boolean(lockedDays[day] || block.locked || block.completed || block.linkedExamId);
  const move = (key: string, target: GridPosition) => {
    const from = locate(grid,key); if (!from || lockedDays[target.day]) { setMessage("این روز قابل ویرایش نیست."); return; }
    const block = grid[from.day][from.index];
    if (!block || protect(block,from.day)) { setMessage("این باکس قابل جابه‌جایی نیست."); return; }
    const next = movePlannerBlock(grid,from,target);
    if (JSON.stringify(next) !== signature) commit(next,key);
  };
  const uniqueKey = () => {
    const taken = new Set(grid.flatMap(day => day.flatMap(block => block ? [block.key] : [])));
    let key = newClientKey(); while (taken.has(key)) key = newClientKey(); return key;
  };
  const insertCopy = (block: PlannerBlock, day: number, index: number) => {
    if (lockedDays[day]) { setMessage("این روز قابل ویرایش نیست."); return; }
    const next = clonePlannerGrid(grid), copied = copyPlannerBlock(block,day,uniqueKey());
    next[day].splice(index,0,copied); commit(next,copied.key); setSelected(copied.key);
  };
  const deleteBlock = (key: string) => {
    const position=locate(grid,key); if (!position) return;
    const block=grid[position.day][position.index];
    if (!block || protect(block,position.day)) { setMessage("این باکس قابل حذف نیست."); return; }
    const next=clonePlannerGrid(grid); next[position.day].splice(position.index,1); commit(next); setSelected(null);
  };
  const pasteDay = (day: number) => {
    if (!dayClipboard || lockedDays[day]) return;
    const next=clonePlannerGrid(grid), used=new Set(grid.flatMap(items=>items.flatMap(block=>block?[block.key]:[])));
    for (const block of dayClipboard) {
      let key=newClientKey(); while(used.has(key)) key=newClientKey(); used.add(key);
      next[day].push(copyPlannerBlock(block,day,key));
    }
    commit(next); setMessage("باکس‌های کپی‌شده اضافه شدند.");
  };
  const keyDown = (event: KeyboardEvent<HTMLButtonElement>, key: string) => {
    const position=locate(grid,key); if (!position) return;
    const block=grid[position.day][position.index]; if (!block) return;
    const control=event.ctrlKey || event.metaKey;
    if (control && event.key.toLowerCase()==="z") { event.preventDefault(); undo(); return; }
    if (control && event.key.toLowerCase()==="c") { event.preventDefault(); setClipboard(block); setMessage("باکس کپی شد."); return; }
    if (control && event.key.toLowerCase()==="v") { event.preventDefault(); if(clipboard) insertCopy(clipboard,position.day,position.index+1); return; }
    if (control && event.key.toLowerCase()==="d") { event.preventDefault(); if(position.day<6) insertCopy(block,position.day+1,grid[position.day+1].length); return; }
    if (event.key==="Delete" || event.key==="Backspace") { event.preventDefault(); deleteBlock(key); return; }
    if (event.altKey && ["ArrowUp","ArrowDown","ArrowLeft","ArrowRight"].includes(event.key)) {
      event.preventDefault();
      if(event.key==="ArrowUp" && position.index>0) move(key,{day:position.day,index:position.index-1});
      else if(event.key==="ArrowDown" && position.index<grid[position.day].length-1) move(key,{day:position.day,index:position.index+2});
      else if(event.key==="ArrowLeft" && position.day<6) move(key,{day:position.day+1,index:Math.min(position.index,grid[position.day+1].length)});
      else if(event.key==="ArrowRight" && position.day>0) move(key,{day:position.day-1,index:Math.min(position.index,grid[position.day-1].length)});
      return;
    }
    if (["ArrowUp","ArrowDown","ArrowLeft","ArrowRight"].includes(event.key)) {
      const day=event.key==="ArrowLeft"?Math.min(6,position.day+1):event.key==="ArrowRight"?Math.max(0,position.day-1):position.day;
      const index=event.key==="ArrowUp"?position.index-1:event.key==="ArrowDown"?position.index+1:position.index;
      const target=grid[day][Math.max(0,Math.min(index,grid[day].length-1))];
      if(target) {event.preventDefault();setSelected(target.key);buttons.current.get(target.key)?.focus();}
    }
  };
  const drop = (event: DragEvent, day: number, index: number) => {
    event.preventDefault(); const key=dragKey.current; dragKey.current=null;
    if(key) move(key,{day,index});
  };
  return <section className={styles.wrap} aria-label="برنامهٔ هفتگی">
    <div className={styles.heading}><h2>برنامهٔ هفته</h2><button type="button" className={styles.utility} onClick={undo} disabled={!canUndo}>بازگرداندن تغییر</button></div>
    <p className={styles.shortcuts}>برای ویرایش روی باکس بزن. جابه‌جایی با کشیدن یا Alt و کلیدهای جهت؛ کپی Ctrl+C، چسباندن Ctrl+V، تکرار Ctrl+D.</p>
    <div className={styles.scroll}><div className={styles.grid}>
      {grid.map((day,dayIndex)=>{
        const date=addDays(parseIsoDate(weekStart),dayIndex), parts=persianParts(date), weekday=formatPersianWeekday(date);
        return <section className={styles.day} key={dayIndex} aria-label={weekday}>
          <header className={styles.dayHeader}><div><strong>{weekday}</strong><small>{persianNumber.format(parts.day)} {persianMonthNames[parts.month-1]}</small></div><button type="button" className={styles.dayButton} disabled={!day.some(Boolean)} onClick={()=>{setDayClipboard(day.filter((block):block is PlannerBlock=>Boolean(block)));setMessage(`${weekday} کپی شد؛ در روز مقصد چسباندن را بزن.`)}}>کپی روز</button></header>
          {dayClipboard && !lockedDays[dayIndex] && <button type="button" className={styles.dayButton} onClick={()=>pasteDay(dayIndex)}>چسباندن روز</button>}
          <div className={styles.items} onDragOver={e=>e.preventDefault()} onDrop={e=>drop(e,dayIndex,day.length)}>
            {day.map((block,index)=>block ? <div key={block.key} className={styles.slot} onDragOver={e=>e.preventDefault()} onDrop={e=>{e.stopPropagation();drop(e,dayIndex,index)}}>
              <button type="button" ref={element=>{if(element) buttons.current.set(block.key,element);else buttons.current.delete(block.key)}} className={`${styles.block} ${selected===block.key?styles.selected:""}`} style={{borderInlineStartColor:subjectColor(block.subject)}} draggable={!protect(block,dayIndex)} onDragStart={()=>{dragKey.current=block.key;setSelected(block.key)}} onDragEnd={()=>{dragKey.current=null}} onFocus={()=>setSelected(block.key)} onClick={()=>{setSelected(block.key);onEdit(block)}} onContextMenu={e=>{e.preventDefault();setSelected(block.key);setMenu(menu===block.key?null:block.key)}} onKeyDown={e=>keyDown(e,block.key)}>
                <strong>{block.subject || "فعالیت جدید"}</strong><span>{block.chapter || "مبحث آزاد"}</span><small>{displayMinutes(block.durationMinutes)}{block.targetTestCount!==null?` · ${persianNumber.format(block.targetTestCount)} تست`:""}</small>{protect(block,dayIndex)&&<small>محافظت‌شده</small>}
              </button>
              <button type="button" className={styles.menuTrigger} aria-label={`گزینه‌های ${block.subject || "باکس"}`} aria-expanded={menu===block.key} onClick={()=>{setSelected(block.key);setMenu(menu===block.key?null:block.key)}}>⋮</button>
              {menu===block.key && <div className={styles.menu}>
                <button type="button" onClick={()=>{setMenu(null);onEdit(block)}}>ویرایش</button>
                <button type="button" onClick={()=>{setClipboard(block);setMenu(null);setMessage("باکس کپی شد.")}}>کپی</button>
                {clipboard&&!lockedDays[dayIndex]&&<button type="button" onClick={()=>insertCopy(clipboard,dayIndex,index+1)}>چسباندن</button>}
                {dayIndex<6&&!lockedDays[dayIndex+1]&&<button type="button" onClick={()=>insertCopy(block,dayIndex+1,grid[dayIndex+1].length)}>تکرار در روز بعد</button>}
                {!protect(block,dayIndex)&&dayIndex>0&&!lockedDays[dayIndex-1]&&<button type="button" onClick={()=>move(block.key,{day:dayIndex-1,index:grid[dayIndex-1].length})}>انتقال به روز قبل</button>}
                {!protect(block,dayIndex)&&dayIndex<6&&!lockedDays[dayIndex+1]&&<button type="button" onClick={()=>move(block.key,{day:dayIndex+1,index:grid[dayIndex+1].length})}>انتقال به روز بعد</button>}
                {!protect(block,dayIndex)&&<button type="button" onClick={()=>deleteBlock(block.key)}>حذف</button>}
              </div>}
            </div> : <div className={styles.empty} key={`empty-${index}`} onDragOver={e=>e.preventDefault()} onDrop={e=>{e.stopPropagation();drop(e,dayIndex,index)}} aria-hidden="true"/>)}
            {Array.from({length:Math.max(0,5-day.length)},(_,index)=><div className={styles.empty} key={`placeholder-${index}`} aria-hidden="true"/>)}
          </div>
          <button type="button" className={styles.add} disabled={lockedDays[dayIndex]} onClick={()=>onAdd(dayIndex)}>+ افزودن</button>
        </section>;
      })}
    </div></div>
    <div className={styles.summary}><strong>خلاصهٔ هفته</strong><span>{displayMinutes(summary.minutes)}</span><span>{persianNumber.format(summary.tests)} تست</span><span>{persianNumber.format(summary.blocks)} باکس</span><span>{persianNumber.format(summary.emptySlots)} جای خالی</span></div>
    <div className={styles.live} role="status" aria-live="polite">{message}</div>
  </section>;
}
