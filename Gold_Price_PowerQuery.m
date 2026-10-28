/* ---------- QUERY 1: Gold (fact table) ---------- */
let
    Source = Excel.Workbook(File.Contents("D:\Data Project\Gold Price\gold_stock.xlsx"), null, true),
    Sheet  = Source{[Item = "gold_stock", Kind = "Sheet"]}[Data],

    // Line 0 = header (Price, Close, ...), Line 1 = "Ticker", Line 2 = "Date" -> Delete the first 3 lines
    DataOnly = Table.Skip(Sheet, 3),
    Renamed  = Table.RenameColumns(DataOnly, {
        {"Column1", "Date"}, {"Column2", "Close"}, {"Column3", "High"},
        {"Column4", "Low"},  {"Column5", "Open"},  {"Column6", "Volume"}}),

    // Data Type (Set the culture to en-US so that the decimal point displays correctly)
    Typed = Table.TransformColumnTypes(Renamed, {
        {"Date", type date}, {"Close", type number}, {"High", type number},
        {"Low", type number}, {"Open", type number}, {"Volume", Int64.Type}}, "en-US"),

    // Clean: remove empty/error rows, duplicate dates, sort
    NoNulls = Table.SelectRows(Typed, each [Date] <> null and [Close] <> null),
    NoDup   = Table.Distinct(NoNulls, {"Date"}),
    Sorted  = Table.Sort(NoDup, {{"Date", Order.Ascending}}),

    // Previous day's price (without a self-join, using a buffer list)
    Indexed   = Table.AddIndexColumn(Sorted, "Idx", 0, 1, Int64.Type),
    CloseBuf  = List.Buffer(Indexed[Close]),
    PrevClose = Table.AddColumn(Indexed, "PrevClose",
                    each if [Idx] = 0 then null else CloseBuf{[Idx] - 1}, type nullable number),

    // Derivative column
    DailyReturn = Table.AddColumn(PrevClose, "DailyReturn",
                    each if [PrevClose] = null then null else [Close] / [PrevClose] - 1, type nullable number),
    RangePct    = Table.AddColumn(DailyReturn, "RangePct",
                    each if [Open] = 0 then null else ([High] - [Low]) / [Open], type nullable number),
    GapPct      = Table.AddColumn(RangePct, "GapPct",
                    each if [PrevClose] = null then null else [Open] / [PrevClose] - 1, type nullable number),
    BodyPct     = Table.AddColumn(GapPct, "BodyPct",
                    each if [Open] = 0 then null else ([Close] - [Open]) / [Open], type nullable number),
    Turnover    = Table.AddColumn(BodyPct, "Turnover", each [Close] * [Volume], type number),

    // OHLC Validation: Low <= Open, Close <= High
    OHLCValid = Table.AddColumn(Turnover, "OHLCValid",
                    each [Low] <= [Open] and [Low] <= [Close] and [High] >= [Open] and [High] >= [Close], type logical),

    // Time Attribute
    Year       = Table.AddColumn(OHLCValid, "Year", each Date.Year([Date]), Int64.Type),
    MonthNum   = Table.AddColumn(Year, "MonthNum", each Date.Month([Date]), Int64.Type),
    WeekdayNum = Table.AddColumn(MonthNum, "WeekdayNum", each Date.DayOfWeek([Date], Day.Monday) + 1, Int64.Type),

    Final = Table.RemoveColumns(WeekdayNum, {"Idx"})
in
    Final


/* ---------- QUERY 2: Calendar (Date Table) ---------- */
let
    StartDate = #date(2014, 1, 1),
    EndDate   = #date(2025, 12, 31),
    Dates     = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1, 0, 0, 0)),
    ToTable   = Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    Typed     = Table.TransformColumnTypes(ToTable, {{"Date", type date}}),

    Cal = Table.AddColumn(Typed, "Year", each Date.Year([Date]), Int64.Type),
    Cal2 = Table.AddColumn(Cal, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),
    Cal3 = Table.AddColumn(Cal2, "MonthNum", each Date.Month([Date]), Int64.Type),
    Cal4 = Table.AddColumn(Cal3, "MonthName",
            each {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}{Date.Month([Date]) - 1}, type text),
    Cal5 = Table.AddColumn(Cal4, "WeekdayNum", each Date.DayOfWeek([Date], Day.Monday) + 1, Int64.Type),
    Cal6 = Table.AddColumn(Cal5, "WeekdayName",
            each {"Mon","Tue","Wed","Thu","Fri","Sat","Sun"}{Date.DayOfWeek([Date], Day.Monday)}, type text),
    Cal7 = Table.AddColumn(Cal6, "YearMonth", each Date.Year([Date]) * 100 + Date.Month([Date]), Int64.Type)
in
    Cal7
