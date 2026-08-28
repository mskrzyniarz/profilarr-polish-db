-- ============================================================================
-- Polish Compact Media PCD - Initial Operations
-- ============================================================================
-- Reuse notes:
-- - Reused patterns from Dictionarry-Hub/database, Dumpstarr/Database, and Dictionarry-Hub/trash-pcd
-- - New patterns were added only for Polish-specific language/group logic and AI labeling

-- ============================================================================
-- TAGS
-- ============================================================================

INSERT INTO tags (name) VALUES ('AI');
INSERT INTO tags (name) VALUES ('Audio');
INSERT INTO tags (name) VALUES ('Banned');
INSERT INTO tags (name) VALUES ('Codec');
INSERT INTO tags (name) VALUES ('HDR');
INSERT INTO tags (name) VALUES ('Language');
INSERT INTO tags (name) VALUES ('LQ');
INSERT INTO tags (name) VALUES ('Polish');
INSERT INTO tags (name) VALUES ('Quality');
INSERT INTO tags (name) VALUES ('Release Group');
INSERT INTO tags (name) VALUES ('Resolution');
INSERT INTO tags (name) VALUES ('Size');
INSERT INTO tags (name) VALUES ('Source');
INSERT INTO tags (name) VALUES ('Subtitles');
INSERT INTO tags (name) VALUES ('Trusted');
INSERT INTO tags (name) VALUES ('Video');
INSERT INTO tags (name) VALUES ('3D');

-- ============================================================================
-- REGULAR EXPRESSIONS
-- ============================================================================

-- Reused from Dictionarry-Hub/database (latest CAM evolution chain)
INSERT INTO regular_expressions (name, pattern, description) VALUES (
    'CAM Core',
    '(?<=\b[12]\d{3}\b).*(\b((AC3)?(LD|MD)|CAM[ ._-]?(Rip)?|DCP(RIP)?|DVD[ ._-]?(SCR(EENER)?)|HD[ ._-]?(CAM|SCR|TC|TS)|(LINE|MIC)[ ._-]?DUBBED|SCREENER|(TC|TS)(Rip)?|TELE(CINE|SYNC)|WORKPRINT)\b)',
    'Reused CAM/LQ pattern lineage from Dictionarry-Hub/database ops 183/192/194/207/208/246/277'
);

-- Reused components split for composability per project requirement
INSERT INTO regular_expressions (name, pattern, description) VALUES (
    'Cam Video',
    '(?i)\b(CAM[ ._-]?(Rip)?|HDCAM)\b',
    'Cam-specific low quality markers'
);

INSERT INTO regular_expressions (name, pattern, description) VALUES (
    'Telesync Video',
    '(?i)\b(HDTS|TELESYNC|PDVD|PreDVDRip|(TC|TS)(Rip)?|TS)\b',
    'Telesync-specific low quality markers'
);

-- Reused from Dictionarry-Hub/database
INSERT INTO regular_expressions (name, pattern, description) VALUES (
    '3D',
    '(?<=\b[12]\d{3}\b).*\b((bluray|bd)?3d|sbs|half[ .-]ou|half[ .-]sbs)\b',
    '3D video markers'
);

-- Reused from Dictionarry-Hub/database / Dumpstarr/Database / trash-pcd
INSERT INTO regular_expressions (name, pattern, description) VALUES ('AV1', '\b(AV1)\b', 'AV1 codec marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('AVC', '[xh][ ._-]?264|\bAVC(\b|\d)', 'AVC/x264 family marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('HEVC x265', '^(?!.*(?i:remux))(?=.*([x]\s?(\.?265)\b|HEVC|\bDS4K\b)).*$', 'HEVC/x265 family marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('10bit', '10[.-]?bit', '10-bit video marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Upscaled', '(?<=\b\d{3,4}p\b).*\b(AI[ ._-]?Enhanced|UPS(UHD)?|Upscaled?([ ._-]?UHD)?|UpRez)\b', 'Upscaled marker reused from Dumpstarr/Database');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Dolby Vision', '\b(dv(?![ .](HLG|SDR))|dovi|dolby[ .]?vision)\b', 'Dolby Vision marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('HDR10+', '\bHDR10.?(\+|P(lus)?\b)', 'HDR10+ marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('HDR10', '\bHDR10(?!\+|Plus)\b', 'HDR10 marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('HDR', '\b(HDR)\b', 'Generic HDR marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Atmos', '\bATMOS|DDPA(\b|\d)', 'Atmos marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('TrueHD', 'True[ .-]?HD[ .-]?', 'TrueHD marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('DTS-HD MA', '\b(dts[-_. ]?(ma|hd([-_. ]?ma)?|xll))(\b|\d)', 'DTS-HD MA marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('DTS-X', '\b(dts[-_. :]?x)\b(?!\d)', 'DTS:X marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Dolby Digital +', '\bDD[P+]|\b(e[-_. ]?ac3)\b', 'Dolby Digital Plus marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Dolby Digital', '\bDD[^a-z+]|(?<!e)ac3', 'Dolby Digital marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('5.1 Surround', '\D5\.1\D', '5.1 marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Line Dubbed', '\b(LD|AC3LD|Line[ .-]?Dubbed)\b', 'Line dubbed marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Mic Dubbed', '\b(MD|AC3MD|Mic[ .-]?Dubbed)\b', 'Mic dubbed marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('MULTi', '(?i)\b(MULTi)(\b|\d)', 'MULTi marker from trash-pcd (case-insensitive adaptation)');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Multi', '\b(Multi)(?![ ._-]?sub(s)?)(\b|\d)', 'Multi marker from trash-pcd');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('1080p or 2160p', '\b(1080p|2160p)\b', 'High-resolution marker used for codec-missing heuristic');

-- Project-specific Polish and AI patterns
INSERT INTO regular_expressions (name, pattern, description) VALUES (
    'Polish Explicit Audio',
    '(?i)(?:\bPL(?:DUB|DUBBING)\b|\bDUBBINGPL\b|\b(?:DUBB?ING?|LEKTOR)[\s._-]*PL\b|\b(?:POLISH|POLSKI)\b|(?<![A-Z])POL(?![A-Z])|\[PL\]|\.POL\.|\[(?:FILM[\s._-]*(?:PL|POLSKI)|POLSKI[\s._-]*FILM)\]|\[(?=[^\]]*PL)(?=[^\]]*(?:LEKTOR|NAPISY|DUBB?ING?|DUBB?))[^\]]+\]|\[(?=[^\]]*PL)(?:AUDIO|MULTI)[\s._-]*[A-Z]{2,}(?:/[A-Z]{2,})*\])',
    'Explicit Polish audio indicators'
);

INSERT INTO regular_expressions (name, pattern, description) VALUES (
    'Polish Subtitles',
    '(?i)(?:\b(?:NAPISY|SUB(?:TITLES|S)?)[\s._-]*(?:PL|POL|POLSKIE)\b|\b(?:PL|POL)[\s._-]*SUB(?:TITLES|S)?\b|\bPOLSKIE[\s._-]*NAPISY\b|\b(?:POLISH|POLAND)[\s._-]*SUB(?:TITLES|S)?\b)',
    'Explicit Polish subtitle indicators'
);

INSERT INTO regular_expressions (name, pattern, description) VALUES (
    'AI Generated Upscaled',
    '(?i)(?:\bAI[\s._-]?(?:DUBB?ING?|DUBB?|AUDIO|LEKTOR|VOICE|NAPISY|SUB(?:S|TITLES)?|UPSCALE[DR]?|UPSCALED|GEN(?:ERATED)?)\b|\b(?:DUBB?ING?|DUBB?|LEKTOR|AUDIO|NAPISY|SUB(?:S|TITLES)?|UPSCALE[DR]?|UPSCALED|GEN(?:ERATED)?)[\s._-]*(?:PL[\s._-]*)?(?:\(|\[)?AI(?:\)|\])?\b|\[(?=[^\]]*\bAI\b)(?=[^\]]*(?:PL|LEKTOR|NAPISY|DUBB?ING?|DUBB?|AUDIO|SUB(?:S|TITLES)?))[^\]]+\])',
    'Explicit AI-generated/upscaled media markers'
);

INSERT INTO regular_expressions (name, pattern, description) VALUES ('PABLO Group', '(?i)(?:\[PABLO\]|-PABLO\b|\bPABLO\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('MAXX Group', '(?i)(?:\[MAXX\]|-MAXX\b|\bMAXX\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('AdL Group', '(?i)(?:\[AdL\]|-AdL\b|\bAdL\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('RX Group', '(?i)(?:\[RX\]|-RX\b|\bRX\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('KiT Group', '(?i)(?:\[KiT\]|-KiT\b|\bKiT\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('DReaM Group', '(?i)(?:\[DReaM\]|-DReaM\b|\bDReaM\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('DENDA Group', '(?i)(?:\[DENDA\]|-DENDA\b|\bDENDA\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('LTN Group', '(?i)(?:\[LTN\]|-LTN\b|\bLTN\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('OzW Group', '(?i)(?:\[OzW\]|-OzW\b|\bOzW\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('wasik Group', '(?i)(?:\[wasik\]|-wasik\b|\bwasik\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('ELiTE Group', '(?i)(?:\[ELiTE\]|-ELiTE\b|\bELiTE\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('LTS Group', '(?i)(?:\[LTS\]|-LTS\b|\bLTS\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('J Group', '(?i)(?:\[J\]|-J\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('DZiDEK Group', '(?i)(?:\[DZiDEK\]|-DZiDEK\b|\bDZiDEK\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('FT Group', '(?i)(?:\[FT\]|-FT\b|\bFT\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('CoLO Group', '(?i)(?:\[CoLO\]|-CoLO\b|\bCoLO\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('MiNS Group', '(?i)(?:\[MiNS\]|-MiNS\b|\bMiNS\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('K83 Group', '(?i)(?:\[K83\]|-K83\b|\bK83\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('DSiTE Group', '(?i)(?:\[DSiTE\]|-DSiTE\b|\bDSiTE\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('GUN Group', '(?i)(?:\[GUN\]|-GUN\b|\bGUN\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('BiRD Group', '(?i)(?:\[BiRD\]|-BiRD\b|\bBiRD\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Ralf Group', '(?i)(?:\[Ralf\]|-Ralf\b|\bRalf\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('S78 Group', '(?i)(?:\[S78\]|-S78\b|\bS78\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('FOX Group', '(?i)(?:\[FOX\]|-FOX\b|\bFOX\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('LLA Group', '(?i)(?:\[LLA\]|-LLA\b|\bLLA\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('S56 Group', '(?i)(?:\[S56\]|-S56\b|\bS56\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('LEX Group', '(?i)(?:\[LEX\]|-LEX\b|\bLEX\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('AZQ Group', '(?i)(?:\[AZQ\]|-AZQ\b|\bAZQ\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('XuploaD Group', '(?i)(?:\[XuploaD\]|-XuploaD\b|\bXuploaD\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('WiKi Group', '(?i)(?:\[WiKi\]|-WiKi\b|\bWiKi\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('K37 Group', '(?i)(?:\[K37\]|-K37\b|\bK37\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('NN Group', '(?i)(?:\[NN\]|-NN\b|\bNN\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('RobSil Group', '(?i)(?:\[RobSil\]|-RobSil\b|\bRobSil\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('KPFR Group', '(?i)(?:\[KPFR\]|-KPFR\b|\bKPFR\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Net Group', '(?i)(?:\[Net\]|-Net\b|\bNet\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('R22 Group', '(?i)(?:\[R22\]|-R22\b|\bR22\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Mixio Group', '(?i)(?:\[Mixio\]|-Mixio\b|\bMixio\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Nitro Group', '(?i)(?:\[Nitro\]|-Nitro\b|\bNitro\b)', 'Trusted Polish release group marker');
INSERT INTO regular_expressions (name, pattern, description) VALUES ('Trusted Polish Group Any', '(?i)(?:\[PABLO\]|-PABLO\b|\bPABLO\b|\[MAXX\]|-MAXX\b|\bMAXX\b|\[AdL\]|-AdL\b|\bAdL\b|\[RX\]|-RX\b|\bRX\b|\[KiT\]|-KiT\b|\bKiT\b|\[DReaM\]|-DReaM\b|\bDReaM\b|\[DENDA\]|-DENDA\b|\bDENDA\b|\[LTN\]|-LTN\b|\bLTN\b|\[OzW\]|-OzW\b|\bOzW\b|\[wasik\]|-wasik\b|\bwasik\b|\[ELiTE\]|-ELiTE\b|\bELiTE\b|\[LTS\]|-LTS\b|\bLTS\b|\[J\]|-J\b|\[DZiDEK\]|-DZiDEK\b|\bDZiDEK\b|\[FT\]|-FT\b|\bFT\b|\[CoLO\]|-CoLO\b|\bCoLO\b|\[MiNS\]|-MiNS\b|\bMiNS\b|\[K83\]|-K83\b|\bK83\b|\[DSiTE\]|-DSiTE\b|\bDSiTE\b|\[GUN\]|-GUN\b|\bGUN\b|\[BiRD\]|-BiRD\b|\bBiRD\b|\[Ralf\]|-Ralf\b|\bRalf\b|\[S78\]|-S78\b|\bS78\b|\[FOX\]|-FOX\b|\bFOX\b|\[LLA\]|-LLA\b|\bLLA\b|\[S56\]|-S56\b|\bS56\b|\[LEX\]|-LEX\b|\bLEX\b|\[AZQ\]|-AZQ\b|\bAZQ\b|\[XuploaD\]|-XuploaD\b|\bXuploaD\b|\[WiKi\]|-WiKi\b|\bWiKi\b|\[K37\]|-K37\b|\bK37\b|\[NN\]|-NN\b|\bNN\b|\[RobSil\]|-RobSil\b|\bRobSil\b|\[KPFR\]|-KPFR\b|\bKPFR\b|\[Net\]|-Net\b|\bNet\b|\[R22\]|-R22\b|\bR22\b|\[Mixio\]|-Mixio\b|\bMixio\b|\[Nitro\]|-Nitro\b|\bNitro\b)', 'Composite guard for trusted Polish groups used by Trusted MULTi logic');

INSERT INTO regular_expressions (name, pattern, description) VALUES (
    'DDP5.1',
    '(?i)\b(DDP5[ .]?1|EAC3[ .]?5[ .]?1)\b',
    'DDP5.1 marker'
);

INSERT INTO regular_expressions (name, pattern, description) VALUES (
    'DD2.0',
    '(?i)\b(DDP?2[ .]?0)\b',
    'DD2.0 marker'
);

-- ============================================================================
-- REGEX TAGS
-- ============================================================================

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('CAM Core', 'Video');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('CAM Core', 'LQ');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('CAM Core', 'Banned');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Cam Video', 'Video');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Cam Video', 'LQ');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Cam Video', 'Banned');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Telesync Video', 'Video');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Telesync Video', 'LQ');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Telesync Video', 'Banned');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('3D', 'Video');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('3D', '3D');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('3D', 'Banned');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AV1', 'Codec');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('HEVC x265', 'Codec');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AVC', 'Codec');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Upscaled', 'AI');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Upscaled', 'Video');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Dolby Vision', 'HDR');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('HDR10+', 'HDR');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('HDR10', 'HDR');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('HDR', 'HDR');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Atmos', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('TrueHD', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DTS-HD MA', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DTS-X', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Dolby Digital +', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Dolby Digital', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('5.1 Surround', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('1080p or 2160p', 'Resolution');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DD2.0', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DDP5.1', 'Audio');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AI Generated Upscaled', 'AI');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AI Generated Upscaled', 'Banned');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AI Generated Upscaled', 'Audio');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AI Generated Upscaled', 'Video');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AI Generated Upscaled', 'Subtitles');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Polish Explicit Audio', 'Language');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Polish Explicit Audio', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Polish Explicit Audio', 'Audio');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Polish Subtitles', 'Language');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Polish Subtitles', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Polish Subtitles', 'Subtitles');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('PABLO Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('PABLO Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('PABLO Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('MAXX Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('MAXX Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('MAXX Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AdL Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AdL Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AdL Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('RX Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('RX Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('RX Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('KiT Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('KiT Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('KiT Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DReaM Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DReaM Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DReaM Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DENDA Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DENDA Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DENDA Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LTN Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LTN Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LTN Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('OzW Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('OzW Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('OzW Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('wasik Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('wasik Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('wasik Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('ELiTE Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('ELiTE Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('ELiTE Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LTS Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LTS Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LTS Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('J Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('J Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('J Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DZiDEK Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DZiDEK Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DZiDEK Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('FT Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('FT Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('FT Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('CoLO Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('CoLO Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('CoLO Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('MiNS Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('MiNS Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('MiNS Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('K83 Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('K83 Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('K83 Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DSiTE Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DSiTE Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('DSiTE Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('GUN Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('GUN Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('GUN Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('BiRD Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('BiRD Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('BiRD Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Ralf Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Ralf Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Ralf Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('S78 Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('S78 Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('S78 Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('FOX Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('FOX Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('FOX Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LLA Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LLA Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LLA Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('S56 Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('S56 Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('S56 Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LEX Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LEX Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('LEX Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AZQ Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AZQ Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('AZQ Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('XuploaD Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('XuploaD Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('XuploaD Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('WiKi Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('WiKi Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('WiKi Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('K37 Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('K37 Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('K37 Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('NN Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('NN Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('NN Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('RobSil Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('RobSil Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('RobSil Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('KPFR Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('KPFR Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('KPFR Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Net Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Net Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Net Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('R22 Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('R22 Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('R22 Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Mixio Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Mixio Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Mixio Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Nitro Group', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Nitro Group', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Nitro Group', 'Trusted');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Trusted Polish Group Any', 'Release Group');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Trusted Polish Group Any', 'Polish');
INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES ('Trusted Polish Group Any', 'Trusted');

-- ============================================================================
-- CUSTOM FORMATS
-- ============================================================================

-- Hard bans
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Unaccepted Media Quality', 'Absolute rejection for CAM/TS/TC/SCREENER/WORKPRINT and low quality dubbed variants', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('3D', 'Reject all 3D releases', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('AI Generated / Upscaled', 'Reject explicit AI-generated or AI-upscaled media markers', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('File Above 12GB', 'Reject movie files larger than 12GB', 0);

-- Language tiers
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Polish Explicit', 'Highest priority explicit Polish audio tier', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Polish Release Group', 'Classification CF for trusted Polish release groups', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Trusted MULTi', 'MULTi plus trusted Polish release group', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Polish Subtitles', 'Polish subtitle fallback tier', 0);

-- Resolution
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Resolution 2160p', 'Resolution preference tier', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Resolution 1080p', 'Resolution preference tier', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Resolution 720p', 'Resolution preference tier', 0);

-- Codec
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Codec AV1', 'Codec preference tier', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Codec HEVC x265', 'Codec preference tier', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Codec AVC x264', 'Codec preference tier', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Codec x265 Missing', 'Penalty when 1080p/2160p release has no AV1/HEVC/AVC codec marker in title', 0);

-- HDR/video features
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Dolby Vision', 'Video enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Dolby Vision Without Fallback', 'Penalty for Dolby Vision releases without HDR fallback marker', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('HDR10+', 'Video enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('HDR10', 'Video enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('HDR', 'Video enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('10bit', 'Video enhancement preference', 0);

-- Audio features
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Atmos', 'Audio enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('DTS:X', 'Audio enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('TrueHD', 'Audio enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('DTS-HD MA', 'Audio enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('DDP5.1', 'Audio enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Dolby Digital Plus', 'Audio enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('DD5.1', 'Audio enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('Dolby Digital', 'Audio enhancement preference', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('DD2.0', 'Audio enhancement preference', 0);

-- Source
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('WEB-DL Source', 'Preferred compact source', 0);
INSERT INTO custom_formats (name, description, include_in_rename) VALUES ('WEBRip Source', 'Secondary compact source', 0);

-- ============================================================================
-- CUSTOM FORMAT TAGS
-- ============================================================================

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Unaccepted Media Quality', 'Banned');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Unaccepted Media Quality', 'LQ');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Unaccepted Media Quality', 'Video');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('3D', 'Banned');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('3D', '3D');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('3D', 'Video');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('AI Generated / Upscaled', 'Banned');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('AI Generated / Upscaled', 'AI');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('AI Generated / Upscaled', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('AI Generated / Upscaled', 'Video');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('AI Generated / Upscaled', 'Subtitles');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('File Above 12GB', 'Banned');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('File Above 12GB', 'Size');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Explicit', 'Language');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Explicit', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Explicit', 'Polish');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Release Group', 'Release Group');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Release Group', 'Polish');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Release Group', 'Trusted');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Trusted MULTi', 'Language');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Trusted MULTi', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Trusted MULTi', 'Polish');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Trusted MULTi', 'Trusted');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Subtitles', 'Language');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Subtitles', 'Subtitles');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Polish Subtitles', 'Polish');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Resolution 2160p', 'Resolution');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Resolution 1080p', 'Resolution');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Resolution 720p', 'Resolution');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Codec AV1', 'Codec');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Codec HEVC x265', 'Codec');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Codec AVC x264', 'Codec');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Codec x265 Missing', 'Codec');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Codec x265 Missing', 'Quality');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Dolby Vision', 'HDR');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Dolby Vision Without Fallback', 'HDR');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Dolby Vision Without Fallback', 'Quality');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('HDR10+', 'HDR');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('HDR10', 'HDR');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('HDR', 'HDR');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('10bit', 'Video');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Atmos', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('DTS:X', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('TrueHD', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('DTS-HD MA', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('DDP5.1', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Dolby Digital Plus', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('DD5.1', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('Dolby Digital', 'Audio');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('DD2.0', 'Audio');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('WEB-DL Source', 'Source');
INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES ('WEBRip Source', 'Source');

-- ============================================================================
-- QUALITY PROFILES
-- ============================================================================

INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment)
VALUES (
    'Polish Compact Movies',
    'Radarr profile focused on compact releases with strict Polish language priority tiers and hard bans.',
    1,
    0,
    589000,
    1
);

INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment)
VALUES (
    'Polish Compact Series',
    'Sonarr profile focused on compact episode releases with strict Polish language priority tiers and hard bans.',
    1,
    0,
    589000,
    1
);

INSERT INTO quality_profile_tags (quality_profile_name, tag_name) VALUES ('Polish Compact Movies', 'Polish');
INSERT INTO quality_profile_tags (quality_profile_name, tag_name) VALUES ('Polish Compact Movies', 'Quality');
INSERT INTO quality_profile_tags (quality_profile_name, tag_name) VALUES ('Polish Compact Series', 'Polish');
INSERT INTO quality_profile_tags (quality_profile_name, tag_name) VALUES ('Polish Compact Series', 'Quality');

INSERT INTO quality_profile_languages (quality_profile_name, language_name, type) VALUES ('Polish Compact Movies', 'Any', 'simple');
INSERT INTO quality_profile_languages (quality_profile_name, language_name, type) VALUES ('Polish Compact Series', 'Any', 'simple');

-- Default delay profile for both Radarr and Sonarr: conservative timing, no custom-score bypass.
INSERT INTO delay_profiles (name, preferred_protocol, usenet_delay, torrent_delay, bypass_if_highest_quality, bypass_if_above_custom_format_score, minimum_custom_format_score)
VALUES ('Polish Compact Delay', 'prefer_torrent', 300, 300, 0, 0, NULL);

-- ============================================================================
-- PROFILE QUALITY ORDERING
-- ============================================================================

-- Radarr
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'WEBDL-2160p', NULL, 1, 1, 1);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'Bluray-2160p', NULL, 2, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'WEBRip-2160p', NULL, 3, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'WEBDL-1080p', NULL, 4, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'Bluray-1080p', NULL, 5, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'WEBRip-1080p', NULL, 6, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'HDTV-1080p', NULL, 7, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'WEBDL-720p', NULL, 8, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'Bluray-720p', NULL, 9, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'WEBRip-720p', NULL, 10, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'HDTV-720p', NULL, 11, 1, 0);

INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'Remux-2160p', NULL, 12, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'Remux-1080p', NULL, 13, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'BR-DISK', NULL, 14, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'DVD-R', NULL, 15, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'DVD', NULL, 16, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'SDTV', NULL, 17, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'DVDSCR', NULL, 18, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'TELECINE', NULL, 19, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'TELESYNC', NULL, 20, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'CAM', NULL, 21, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Movies', 'WORKPRINT', NULL, 22, 0, 0);

-- Sonarr
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'WEBDL-2160p', NULL, 1, 1, 1);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'Bluray-2160p', NULL, 2, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'WEBRip-2160p', NULL, 3, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'WEBDL-1080p', NULL, 4, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'Bluray-1080p', NULL, 5, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'WEBRip-1080p', NULL, 6, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'HDTV-1080p', NULL, 7, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'WEBDL-720p', NULL, 8, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'Bluray-720p', NULL, 9, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'WEBRip-720p', NULL, 10, 1, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'HDTV-720p', NULL, 11, 1, 0);

INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'Remux-2160p', NULL, 12, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'Remux-1080p', NULL, 13, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'DVD', NULL, 14, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'SDTV', NULL, 15, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'DVDSCR', NULL, 16, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'TELECINE', NULL, 17, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'TELESYNC', NULL, 18, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'CAM', NULL, 19, 0, 0);
INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, quality_group_name, position, enabled, upgrade_until) VALUES ('Polish Compact Series', 'WORKPRINT', NULL, 20, 0, 0);

-- ============================================================================
-- CUSTOM FORMAT CONDITIONS
-- ============================================================================

-- Unaccepted Media Quality
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Unaccepted Media Quality', 'CAM Core', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Unaccepted Media Quality', 'Cam Video', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Unaccepted Media Quality', 'Telesync Video', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Unaccepted Media Quality', 'Line Dubbed', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Unaccepted Media Quality', 'Mic Dubbed', 'release_title', 'all', 0, 0);

-- 3D
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('3D', '3D', 'release_title', 'all', 0, 1);

-- AI
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('AI Generated / Upscaled', 'AI Marker', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('AI Generated / Upscaled', 'Upscaled Marker', 'release_title', 'all', 0, 0);

-- File Above 12GB (Radarr only)
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('File Above 12GB', 'Above 12GB', 'size', 'radarr', 0, 1);

-- Language tiers
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Explicit', 'Polish Explicit Audio', 'release_title', 'all', 0, 1);

INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'PABLO', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'MAXX', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'AdL', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'RX', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'KiT', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'DReaM', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'DENDA', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'LTN', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'OzW', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'wasik', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'ELiTE', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'LTS', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'J', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'DZiDEK', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'FT', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'CoLO', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'MiNS', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'K83', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'DSiTE', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'GUN', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'BiRD', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'Ralf', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'S78', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'FOX', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'LLA', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'S56', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'LEX', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'AZQ', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'XuploaD', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'WiKi', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'K37', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'NN', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'RobSil', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'KPFR', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'Net', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'R22', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'Mixio', 'release_title', 'all', 0, 0);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Release Group', 'Nitro', 'release_title', 'all', 0, 0);

INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Trusted MULTi', 'MULTi', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Trusted MULTi', 'Trusted Polish Group Any', 'release_title', 'all', 0, 1);

INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Polish Subtitles', 'Polish Subtitles', 'release_title', 'all', 0, 1);

-- Resolution
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Resolution 2160p', '2160p', 'resolution', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Resolution 1080p', '1080p', 'resolution', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Resolution 720p', '720p', 'resolution', 'all', 0, 1);

-- Codec
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec AV1', 'AV1', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec HEVC x265', 'HEVC x265', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec AVC x264', 'AVC', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec AVC x264', 'Not AV1', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec AVC x264', 'Not HEVC x265', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec x265 Missing', '1080p or 2160p', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec x265 Missing', 'Not AV1', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec x265 Missing', 'Not HEVC x265', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Codec x265 Missing', 'Not AVC', 'release_title', 'all', 1, 1);

-- HDR
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Vision', 'Dolby Vision', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Vision Without Fallback', 'Dolby Vision', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Vision Without Fallback', 'Not HDR10+', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Vision Without Fallback', 'Not HDR10', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Vision Without Fallback', 'Not HDR', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR10+', 'HDR10+', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR10+', 'Not Dolby Vision', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR10', 'HDR10', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR10', 'Not Dolby Vision', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR10', 'Not HDR10+', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR', 'HDR', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR', 'Not Dolby Vision', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR', 'Not HDR10+', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('HDR', 'Not HDR10', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('10bit', '10bit', 'release_title', 'all', 0, 1);

-- Audio
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Atmos', 'Atmos', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DTS:X', 'DTS-X', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('TrueHD', 'TrueHD', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('TrueHD', 'Not Atmos', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DTS-HD MA', 'DTS-HD MA', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DTS-HD MA', 'Not DTS-X', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DDP5.1', 'DDP5.1', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Digital Plus', 'Dolby Digital +', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Digital Plus', 'Not DDP5.1', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD5.1', '5.1', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD5.1', 'Not Atmos', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD5.1', 'Not DTS-X', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD5.1', 'Not TrueHD', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD5.1', 'Not DTS-HD MA', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD5.1', 'Not DDP5.1', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Digital', 'Dolby Digital', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('Dolby Digital', 'Not Dolby Digital +', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD2.0', 'DD2.0', 'release_title', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD2.0', 'Not DDP5.1', 'release_title', 'all', 1, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('DD2.0', 'Not Atmos', 'release_title', 'all', 1, 1);

-- Source
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('WEB-DL Source', 'WEBDL', 'source', 'all', 0, 1);
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES ('WEBRip Source', 'WEBRip', 'source', 'all', 0, 1);

-- ============================================================================
-- CONDITION VALUE MAPPINGS
-- ============================================================================

-- Pattern bindings
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Unaccepted Media Quality', 'CAM Core', 'CAM Core');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Unaccepted Media Quality', 'Cam Video', 'Cam Video');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Unaccepted Media Quality', 'Telesync Video', 'Telesync Video');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Unaccepted Media Quality', 'Line Dubbed', 'Line Dubbed');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Unaccepted Media Quality', 'Mic Dubbed', 'Mic Dubbed');

INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('3D', '3D', '3D');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('AI Generated / Upscaled', 'AI Marker', 'AI Generated Upscaled');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('AI Generated / Upscaled', 'Upscaled Marker', 'Upscaled');

INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Explicit', 'Polish Explicit Audio', 'Polish Explicit Audio');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'PABLO', 'PABLO Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'MAXX', 'MAXX Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'AdL', 'AdL Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'RX', 'RX Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'KiT', 'KiT Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'DReaM', 'DReaM Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'DENDA', 'DENDA Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'LTN', 'LTN Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'OzW', 'OzW Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'wasik', 'wasik Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'ELiTE', 'ELiTE Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'LTS', 'LTS Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'J', 'J Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'DZiDEK', 'DZiDEK Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'FT', 'FT Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'CoLO', 'CoLO Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'MiNS', 'MiNS Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'K83', 'K83 Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'DSiTE', 'DSiTE Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'GUN', 'GUN Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'BiRD', 'BiRD Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'Ralf', 'Ralf Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'S78', 'S78 Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'FOX', 'FOX Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'LLA', 'LLA Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'S56', 'S56 Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'LEX', 'LEX Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'AZQ', 'AZQ Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'XuploaD', 'XuploaD Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'WiKi', 'WiKi Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'K37', 'K37 Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'NN', 'NN Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'RobSil', 'RobSil Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'KPFR', 'KPFR Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'Net', 'Net Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'R22', 'R22 Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'Mixio', 'Mixio Group');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Release Group', 'Nitro', 'Nitro Group');

INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Trusted MULTi', 'MULTi', 'MULTi');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Trusted MULTi', 'Trusted Polish Group Any', 'Trusted Polish Group Any');

INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Polish Subtitles', 'Polish Subtitles', 'Polish Subtitles');

INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec AV1', 'AV1', 'AV1');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec HEVC x265', 'HEVC x265', 'HEVC x265');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec AVC x264', 'AVC', 'AVC');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec AVC x264', 'Not AV1', 'AV1');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec AVC x264', 'Not HEVC x265', 'HEVC x265');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec x265 Missing', '1080p or 2160p', '1080p or 2160p');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec x265 Missing', 'Not AV1', 'AV1');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec x265 Missing', 'Not HEVC x265', 'HEVC x265');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Codec x265 Missing', 'Not AVC', 'AVC');

INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Vision', 'Dolby Vision', 'Dolby Vision');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Vision Without Fallback', 'Dolby Vision', 'Dolby Vision');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Vision Without Fallback', 'Not HDR10+', 'HDR10+');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Vision Without Fallback', 'Not HDR10', 'HDR10');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Vision Without Fallback', 'Not HDR', 'HDR');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR10+', 'HDR10+', 'HDR10+');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR10+', 'Not Dolby Vision', 'Dolby Vision');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR10', 'HDR10', 'HDR10');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR10', 'Not Dolby Vision', 'Dolby Vision');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR10', 'Not HDR10+', 'HDR10+');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR', 'HDR', 'HDR');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR', 'Not Dolby Vision', 'Dolby Vision');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR', 'Not HDR10+', 'HDR10+');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('HDR', 'Not HDR10', 'HDR10');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('10bit', '10bit', '10bit');

INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Atmos', 'Atmos', 'Atmos');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DTS:X', 'DTS-X', 'DTS-X');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('TrueHD', 'TrueHD', 'TrueHD');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('TrueHD', 'Not Atmos', 'Atmos');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DTS-HD MA', 'DTS-HD MA', 'DTS-HD MA');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DTS-HD MA', 'Not DTS-X', 'DTS-X');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DDP5.1', 'DDP5.1', 'DDP5.1');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Digital Plus', 'Dolby Digital +', 'Dolby Digital +');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Digital Plus', 'Not DDP5.1', 'DDP5.1');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD5.1', '5.1', '5.1 Surround');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD5.1', 'Not Atmos', 'Atmos');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD5.1', 'Not DTS-X', 'DTS-X');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD5.1', 'Not TrueHD', 'TrueHD');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD5.1', 'Not DTS-HD MA', 'DTS-HD MA');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD5.1', 'Not DDP5.1', 'DDP5.1');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Digital', 'Dolby Digital', 'Dolby Digital');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('Dolby Digital', 'Not Dolby Digital +', 'Dolby Digital +');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD2.0', 'DD2.0', 'DD2.0');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD2.0', 'Not DDP5.1', 'DDP5.1');
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES ('DD2.0', 'Not Atmos', 'Atmos');

-- Resolution/source bindings
INSERT INTO condition_resolutions (custom_format_name, condition_name, resolution) VALUES ('Resolution 2160p', '2160p', '2160p');
INSERT INTO condition_resolutions (custom_format_name, condition_name, resolution) VALUES ('Resolution 1080p', '1080p', '1080p');
INSERT INTO condition_resolutions (custom_format_name, condition_name, resolution) VALUES ('Resolution 720p', '720p', '720p');

INSERT INTO condition_sources (custom_format_name, condition_name, source) VALUES ('WEB-DL Source', 'WEBDL', 'WEBDL');
INSERT INTO condition_sources (custom_format_name, condition_name, source) VALUES ('WEBRip Source', 'WEBRip', 'WEBRIP');

-- Size binding
INSERT INTO condition_sizes (custom_format_name, condition_name, min_bytes, max_bytes) VALUES ('File Above 12GB', 'Above 12GB', 12884901889, NULL);

-- ============================================================================
-- PROFILE CUSTOM FORMAT SCORING
-- ============================================================================

-- Hard bans
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Unaccepted Media Quality', 'radarr', -999999);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', '3D', 'radarr', -999999);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'AI Generated / Upscaled', 'radarr', -999999);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'File Above 12GB', 'radarr', -999999);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Unaccepted Media Quality', 'sonarr', -999999);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', '3D', 'sonarr', -999999);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'AI Generated / Upscaled', 'sonarr', -999999);

-- Language tiers
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Polish Explicit', 'radarr', 500000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Trusted MULTi', 'radarr', 400000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Polish Subtitles', 'radarr', 300000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Polish Release Group', 'radarr', 0);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Polish Explicit', 'sonarr', 500000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Trusted MULTi', 'sonarr', 400000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Polish Subtitles', 'sonarr', 300000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Polish Release Group', 'sonarr', 0);

-- Technical: shared values
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Resolution 2160p', 'radarr', 40000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Resolution 1080p', 'radarr', 25000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Resolution 720p', 'radarr', 10000);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Codec AV1', 'radarr', 20000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Codec HEVC x265', 'radarr', 15000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Codec AVC x264', 'radarr', 5000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Codec x265 Missing', 'radarr', -2000);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Dolby Vision', 'radarr', 10000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Dolby Vision Without Fallback', 'radarr', -6000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'HDR10+', 'radarr', 9000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'HDR10', 'radarr', 7000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'HDR', 'radarr', 5000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', '10bit', 'radarr', 3000);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Atmos', 'radarr', 8000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'DTS:X', 'radarr', 7000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'TrueHD', 'radarr', 6000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'DTS-HD MA', 'radarr', 5500);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'DDP5.1', 'radarr', 4500);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Dolby Digital Plus', 'radarr', 4000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'DD5.1', 'radarr', 3000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'Dolby Digital', 'radarr', 2000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'DD2.0', 'radarr', 1000);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'WEB-DL Source', 'radarr', 8000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Movies', 'WEBRip Source', 'radarr', 4000);

-- Sonarr copy
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Resolution 2160p', 'sonarr', 40000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Resolution 1080p', 'sonarr', 25000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Resolution 720p', 'sonarr', 10000);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Codec AV1', 'sonarr', 20000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Codec HEVC x265', 'sonarr', 15000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Codec AVC x264', 'sonarr', 5000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Codec x265 Missing', 'sonarr', -2000);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Dolby Vision', 'sonarr', 10000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Dolby Vision Without Fallback', 'sonarr', -6000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'HDR10+', 'sonarr', 9000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'HDR10', 'sonarr', 7000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'HDR', 'sonarr', 5000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', '10bit', 'sonarr', 3000);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Atmos', 'sonarr', 8000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'DTS:X', 'sonarr', 7000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'TrueHD', 'sonarr', 6000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'DTS-HD MA', 'sonarr', 5500);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'DDP5.1', 'sonarr', 4500);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Dolby Digital Plus', 'sonarr', 4000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'DD5.1', 'sonarr', 3000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'Dolby Digital', 'sonarr', 2000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'DD2.0', 'sonarr', 1000);

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'WEB-DL Source', 'sonarr', 8000);
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score) VALUES ('Polish Compact Series', 'WEBRip Source', 'sonarr', 4000);

-- ============================================================================
-- QUALITY DEFINITIONS
-- Unit assumption follows Arr-style rate values to target compact outcomes.
-- ============================================================================

-- Radarr: tuned for ~100 minute movies (target ~5-8.5GB at 2160p, ~2.5-5GB at 1080p, ~1-3GB at 720p; hard cap >12GB enforced by CF)
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'WEBDL-2160p', 3000, 8500, 6200);
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'WEBRip-2160p', 2600, 7600, 5600);
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'Bluray-2160p', 3200, 9000, 6700);
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'WEBDL-1080p', 1500, 5000, 3300);
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'WEBRip-1080p', 1300, 4500, 3000);
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'Bluray-1080p', 1700, 5500, 3600);
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'WEBDL-720p', 600, 1800, 1200);
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'WEBRip-720p', 500, 1600, 1000);
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Radarr', 'Bluray-720p', 700, 2000, 1300);

-- Sonarr: tuned for compact episodes and season packs (target ~1-3GB at 2160p, ~0.7-2GB at 1080p, ~0.35-1GB at 720p per episode)
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'WEBDL-2160p', 1000, 3000, 2100);
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'WEBRip-2160p', 900, 2700, 1900);
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'Bluray-2160p', 1100, 3200, 2200);
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'WEBDL-1080p', 700, 2000, 1400);
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'WEBRip-1080p', 600, 1800, 1200);
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'Bluray-1080p', 800, 2200, 1500);
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'WEBDL-720p', 350, 1000, 700);
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'WEBRip-720p', 300, 900, 600);
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size) VALUES ('Polish Compact Sonarr', 'Bluray-720p', 400, 1100, 750);

-- ============================================================================
-- TEST CORPUS
-- ============================================================================

-- Unaccepted Media Quality
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Unaccepted Media Quality', 'Example Movie Title (2026) [PLDUB] [1080p] [MD] [CAM] [x264-OzW] [Dubbing PL]', 'movie', 1, 'Contains CAM and MD markers');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Unaccepted Media Quality', 'Example Movie Title (2026) PLDUB.MD.1080p.HDTS.XiD-MAXX / Dubbing PL', 'movie', 1, 'Contains HDTS and MD markers');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Unaccepted Media Quality', 'Example Movie Title (2026) [720p] [WEB-DL] [XviD] [AC3-OzW] [Dubbing PL]', 'movie', 0, 'No low-quality banned markers');

-- AI ban
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('AI Generated / Upscaled', 'Example Movie Title (2026) [1080p] [DCPRiP] [DD2.0] [x265-AdL] [Napisy PL (AI)]', 'movie', 1, 'Explicit AI subtitle marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('AI Generated / Upscaled', 'Example Movie Title (2026) PLDUB.1080p.AMZN.WEB-DL.H264.AC3-MAXX / Dubbing PL (Oficjalny)', 'movie', 0, 'No AI marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('AI Generated / Upscaled', 'Example Movie Title (2026) [Lektor PL AI] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Lektor PL AI must be banned');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('AI Generated / Upscaled', 'Example Movie Title (2026) [Lektor PL i Napisy PL AI] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Lektor/Napisy with AI must be banned');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('AI Generated / Upscaled', 'Example Movie Title (2026) [Dubbing PL & Napisy PL AI] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Dubbing/Napisy with AI must be banned');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('AI Generated / Upscaled', 'Example Movie Title (2026) [Dubb PL & PL AI] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Dubb variant with AI must be banned');

-- Dolby Vision without fallback penalty
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Dolby Vision Without Fallback', 'Example Movie Title (2026) 2160p.WEB-DL.DV.10bit.DDP5.1-MAXX', 'movie', 1, 'Dolby Vision marker without HDR fallback marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Dolby Vision Without Fallback', 'Example Movie Title (2026) 2160p.WEB-DL.DV.HDR10Plus.10bit.DDP5.1-MAXX', 'movie', 0, 'Dolby Vision with HDR fallback marker');

-- Codec marker missing penalty
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Codec x265 Missing', 'Example Movie Title (2026) 2160p.WEB-DL.DV.HDR10Plus.DDP5.1-MAXX', 'movie', 1, '1080p/2160p release without AV1/HEVC/AVC marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Codec x265 Missing', 'Example Movie Title (2026) 1080p.WEB-DL.HEVC.DDP5.1-MAXX', 'movie', 0, 'Has HEVC marker');

-- 3D ban
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('3D', 'Example Movie Title (2026) 1080p.BluRay3D.DD5.1.x264-GROUP', 'movie', 1, 'Contains BluRay3D marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('3D', 'Example Movie Title (2026) 2160p.WEB-DL.DV.HDR10Plus.AV1-MAXX', 'movie', 0, 'No 3D marker');

-- Polish Explicit
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) PLDUB.2160p.MA.WEB-DL.DV.HDR.AV1.DDP5.1-MAXX / Dubbing PL (Oficjalny)', 'movie', 1, 'PLDUB explicit audio marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) MULTi.1080p.AMZN.WEB-DL.x264.AC3-KiT / Dubbing PL & Napisy PL', 'movie', 1, 'Dubbing PL explicit audio marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [1080p] [Lektor/NapisyPL] [WEB-DL] [H.264-FOX]', 'movie', 1, 'Bracketed Lektor/NapisyPL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [1080p] [Dubbing/NapisyPL] [WEB-DL] [H.264-FOX]', 'movie', 1, 'Bracketed Dubbing/NapisyPL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [2160p] [Audio-EN/FR/PL] [WEB-DL] [HEVC-KiT]', 'movie', 1, 'Bracketed Audio list includes PL in non-first position');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [2160p] [Audio.EN/PL] [WEB-DL] [HEVC-KiT]', 'movie', 1, 'Bracketed Audio list with dot separator includes PL');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [Film PL] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Film PL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [Film Polski] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Film Polski marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [Polski Film] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Polski Film marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [NapisyDubbingPL] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Concatenated NapisyDubbingPL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [DubbPLNapisyPL] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Concatenated DubbPLNapisyPL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [NapisyPLLektorPL] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Concatenated NapisyPLLektorPL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [MULTI-EN/FR/PL] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, 'MULTI list with PL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) .POL. [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, '.POL. marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [PL] [1080p] [WEB-DL] [H.264-KiT]', 'movie', 1, '[PL] marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Explicit', 'Example Movie Title (2026) [MULTi] [1080p] [AMZN] [WEB-DL] [H.264] [DD5.1-RX]', 'movie', 0, 'No explicit PL audio marker');

-- Polish Release Group
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Release Group', 'Example Movie Title (2026) MULTi.1080p.AMZN.WEB-DL.x264.AC3-KiT', 'movie', 1, 'Trusted KiT marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Release Group', 'Example Movie Title (2026) [MULTi] [1080p] [AMZN] [WEB-DL] [H.264] [DD5.1-RX]', 'movie', 1, 'Trusted RX marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Release Group', 'Example Movie Title (2026) [720p] [WEB-DL] [XviD] [AC3-OzW] [Dubbing PL]', 'movie', 1, 'Trusted OzW marker');

-- Trusted MULTi
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Trusted MULTi', 'Example Movie Title (2026) MULTi.1080p.AMZN.WEB-DL.x264.AC3-KiT', 'movie', 1, 'MULTi + trusted group');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Trusted MULTi', 'Example Movie Title [WEB-DL] [Multi] [2160p] [h265] [HDR10] [DUBBING i NAPISY PL] [PABLO].mkv', 'movie', 1, 'Multi + trusted group');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Trusted MULTi', 'Example Movie Title (2026) [MULTi] [1080p] [AMZN] [WEB-DL] [H.264] [DD5.1-UNKNOWN]', 'movie', 0, 'MULTi without trusted group');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Trusted MULTi', 'Example Movie Title (2026) 1080p.WEB-DL.x264.AC3-KiT', 'movie', 0, 'Trusted group without MULTi');

-- Polish Subtitles
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [DCPRiP] [DD2.0] [x265-AdL] [Napisy PL (AI)]', 'movie', 1, 'Polish subtitles marker present');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [720p] [WEB-DL] [XviD] [AC3-OzW] [Dubbing PL]', 'movie', 0, 'No subtitle marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [NAPISY POL] [WEB-DL] [H.264-KiT]', 'movie', 1, 'NAPISY POL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [SUB POL] [WEB-DL] [H.264-KiT]', 'movie', 1, 'SUB POL marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [PL SUB] [WEB-DL] [H.264-KiT]', 'movie', 1, 'PL SUB marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [POL SUB] [WEB-DL] [H.264-KiT]', 'movie', 1, 'POL SUB marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [Napisy Polskie] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Napisy Polskie marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [Polskie Napisy] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Polskie Napisy marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [Polish Subtitles] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Polish Subtitles marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [Polish Sub] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Polish Sub marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [Polish Subs] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Polish Subs marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [Poland Subtitles] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Poland Subtitles marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [Poland Sub] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Poland Sub marker');
INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description) VALUES ('Polish Subtitles', 'Example Movie Title (2026) [1080p] [Poland Subs] [WEB-DL] [H.264-KiT]', 'movie', 1, 'Poland Subs marker');
