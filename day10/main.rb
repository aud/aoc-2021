#!/usr/bin/env ruby
# frozen_string_literal: true

require "pry-byebug"

# Some lines are incomplete, but others are corrupted. Find and discard the corrupted lines first.

# A corrupted line is one where a chunk closes with the wrong character - that is, where the characters it opens and closes with do not form one of the four legal pairs listed above.

# Examples of corrupted chunks include (], {()()()>, (((()))}, and <([]){()}[{}]). Such a chunk can appear anywhere within a line, and its presence causes the whole line to be considered corrupted.

# [({(<(())[]>[[{[]{<()<>>       == INCOMPLETE
# [(()[<>])]({[<{<<[]>>(         == INCOMPLETE
# {([(<{}[<>[]}>{[]{[(<()>       == CORRUPTED, Expected ], but found } instead.
# (((({<>}<{<{<>}{[]{[]{}        == INCOMPLETE
# [[<[([]))<([[{}[[()]]]         == CORRUPTED, Expected ], but found ) instead.
# [{[{({}]{}}([{[{{{}}([]        == CORRUPTED, Expected ), but found ] instead.
# {<[[]]>}<{[{[{[]{()[[[]        == INCOMPLETE
# [<(<(<(<{}))><([]([]()         == CORRUPTED, Expected >, but found ) instead.
# <{([([[(<>()){}]>(<<{{         == CORRUPTED, Expected ], but found > instead.
# <{([{{}}[<[[[<>{}]]]>[]]       == INCOMPLETE

PART_1_POINT_TABLE = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137,
}.freeze

PART_2_POINT_TABLE = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4,
}.freeze

DELIMITERS = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">",
}.freeze

def input
  @input ||= DATA.read.split("\n").map(&:chars)
end

def calculate_score(line)
  stack = []

  line.each do |delim|
    if DELIMITERS.keys.include?(delim)
      stack.push(delim)
    end

    next unless DELIMITERS.values.include?(delim)

    if DELIMITERS[stack.last] == delim
      stack.pop
    else
      return PART_1_POINT_TABLE[delim]
    end
  end

  0
end

def calculate_score2(line)
  stack = []

  line.each do |delim|
    if DELIMITERS.keys.include?(delim)
      stack.push(delim)
    end

    if DELIMITERS.values.include?(delim)
      return false unless DELIMITERS[stack.last] == delim
      stack.pop
    end
  end

  stack.reverse.map do |delim|
    DELIMITERS[delim]
  end.reduce(0) do |acc, delim|
    acc *= 5
    acc += PART_2_POINT_TABLE[delim]
  end
end

def part1
  input.sum { |line| calculate_score(line) }
end

def part2
  result = input.filter_map { |line| calculate_score2(line) }
  result.sort!
  result[(result.length - 1) / 2]
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"

__END__
{{{[(<<[[[<<([[]()]<()<>>)((()()))>([(()><{}[]>]({()[]}))>{[{(<>[]){{}[]}}<({}()){{}[]}>][<<(){}>(()<>)>{[{
{<<((({{<<[<<{[]()}(())>([[]()])><[[{}{}]<[]<>>](({}())[{}<>])>][([{[]{}}](<<>{}>{()()})){({[]{}}<<><>>}{({}
(<[{<{<(<[[<<<[][]>(<>)>><{<(){}>{[]{}}}<{{}[]}{()[]}]>][<([{}<>]<[]<>>)<{[]()}[()<>]>>[{{<><>}<<>{
([{([{{{<[[{[{{}()}<{}[]>]{{<>()}<()>}}{<<{}()>{<>{}}>}]]<(<<[<><>]<<><>>>{<{}()>({}())}>){(<{()<>}><<<
{(<{[{[{([<<{<()()>((){})}[[{}{})<()[]>]>>{([<{}<>><<>[]>]<{<>[]}[{}<>]>){<[<><>]{{}{}}><(
[<([<(<{[<[{<<()[]>{()[]}>}{<[{}][[]{}]){[()()]{<>[]}}}]>{(<(<[]()><{}<>>)(<{}<>><{}()>)><<(<>())>>)
(<{<[<[(({([(([][])([]())){(()[]){[][]}}][({[][]})[[[]{}]({}[])]])}{{{[{<>()}{()[]}](<{}[]><[]<>>)}<(
<<(({([[[([{[[()()]{<>[]}]<[<>[]]({}[])>}]((<[[]())(()<>)>(<{}()>([][])))<([<>[]](()[]))>))[<[[<{}<>>([][])]
(({[{[{<(({([{[]{}}(()())]{{()()}<<>()>})([{{}{}}[{}{}]]<<(){}>[()<>]>)}<{{(()[])}}{{[[]()
[<{<<<{<[[[[(((){})(()[])){<[]{}>}](<[<>[]][<>()]><[()<>]<<>[]>>)]({{[<><>]}<<<>{}>[{}<>]>}[{{{}{}}([]{})}
{[<({<{{<([(<<<>{}>{<>[]}>{{()<>}<<>{}>})(<<[]>((){})>)][<[<()<>>[()]]<((){})<<><>>>>[<{()[]}<{}[]>>]])>}{{<
([[<{([{<<[{<[{}<>]{<>{}}>{[(){}][()()]}}<{(<>[])(<>())}([<><>])>]>{{{<([][]){<>()}>{([]()><()()>}}{{({}()
(<[[({{<([[[[{{}<>}[<>()]][(<>[])<<>()>]]]([([[]()][()()])]([[{}[]]<{}[]>]{[{}<>]{<><>}}))))>(
<<{[([(<<({{([{}[]]<<>()>)<<()[]>[{}<>]>}({(<><>)[{}()]})}[{<[(){}]>{{<>[]}[<>{}]}}[<(<><>){{}[]}>{{<>{
[<({[({[<{[(<[{}()][{}<>]>{{()[]}(<>())})({{{}<>}<[]()>}{<()<>>})]}[<<{{[]}({}{})}([[]<>][()<>])>>[[[
(<<[[<{<(<<<<[()[]]<<>()>>({[]<>}[[]()])>([<<><>>](([]()){[]()}))>{<[{{}<>}<<>[]>]<<<>><[]()>>>{
<[[{[<({{[{(<([]())<{}[]>>(<<>{}>{<>})){[{[][]}{<>[]}]{[[]{}]<[]>}}}<<(([]{})[<>{}]){[{}()](<>{})}>[[([]{})[{
([(<[<[[{([[(({}{})[(){}])([<>[]]{()[]})]([[()<>][<><>]])]{[<{[][]}[[][]]>{<[]()><()[]>}]<[(<>())<<>{}>]>})}
([([{<<{{{({<<<>[]><<><>>>[[<>[]]<[]()>]}<<{[][]}[{}<>]>{[<>()]{()[]}}>)[[[<<><>>{(){}}>[({}[
[[<[[({{(<[{<{[]{}>>({[]()}{[]<>})}{(([]{})[<>{}])[(<>{})<[][]>]}]>){{<[{<{}<>>}<([][])([]<>)>]((<(){}>(()
([[{<[<((<{([{[]<>}({}[])]){{[[]]{<><>}}[<[][]>([][])]}}{[(((){})([]())>]{{{[]()}<<>()>}}}>){<[(
{<(<{{<{[{<{{<(){}>{<><>}}}[{[{}<>][{}<>]}[[[]{}](()[])]]>}][<<<{[{}[]]<()()>}(((){})[()[]])>)((<(()
{([<{<{([(<{[{{}[]}[(){}]]<{()}<{}()>>}[[[[]{}]{<>[]}}]>{[[[<>]<<>()>]{<()<>>{[]<>}}]})<<{[{<>()}<{}<>>]
{<<(<[<[[[[{{(()())([]<>)](<<>>({}()))}<[{<>()}[()<>]]>]({[[[]()]<()<>>]}[[<[]<>><()<>>]{<{}()>[
[<{(<<[<[(<[{(<>{})<{}()>}]<[[()<>]{<>()}]>>)]](({<{<[()()]{[]()}>((<>())(<>{}))}{[<{}()>]<(<>[
[<({({[[[<{<[[()<>]<<><>>]{([]<>)([][])}>[[(<>[]){(){}}]]}{{<{<>{}}<<>>>(([]{})[[]<>])}[<(()[]){{}{}}>]}>[{
{(<<{<[{[{({{[<><>]{{}[]}}}(([{}[]]<[]<>>)})[<(<[]{}><<>()>)[<{}<>>[<>[]]]>(<((){})[{}<>]>{(
[<(({<<([{[{{{<><>}([]<>)}}]}](<(<[([][])<{}[]>]{{{}{}}[{}{}]}>{(<[][]>{{}{}})})>)){[([{{<[][]><()>}
[({[[[(<<((<(<{}()>([]<>))(<()()}<{}[]>)>(([{}[]](<>{}))[{[]<>}(<>[])])))>>)][<{({<[[<{}{}>{[]()}]{(<>{}){
{(([((([<[{[(({}[]){()<>})[[{}[]]({}())]]{<[[][]](()<>)>{[{}[]]{[]()}}}}<{(<<><>><()<>>)<({}[])
{([{{[[{<({([[<><>]<{}<>>]<[()[]]<()[]>>)}[[{[{}{}]{{}{}}}]{[{[]{}}([]{})]{(()())[<>()]})])>}]<
([<[{{{([{{<[[{}{}]]{<()()>}>{{{()[]}([]())}}}<<{<[][]>{<>{}}}>{[[{}()]([]{})]{([]{})(()())}}>}])<<<((<<{}{}
[{{[<[[[<({[[<(){}>{{}[])]{{[]<>}([])}]}<({{<>()}[{}{}]}{[()()]{[]<>}})[{[()<>][()[]]}]>)>[<(<{{
(<{{({{{[({([({}[])<{}{}>](([]{})[{}{}]))})[(<<((){}){()<>}>[[[]<>][{}[]]]>{<([]){{}<>}>([[]{}])}){[(((
<[<{{(<(<<[{([(){}][()()])((<>())]}]>>)>)}[{(({({[[{(){}}]][{(()()){{}[]}}<(()())(<>())>]}{([{[]<>}<[]<>>]
{({<[[<<{<{(({<>{}}<<>{}>))[<<{}()><<>()>><<(){}>({}())>]}<(([{}[]][{}{}]){<{}>}){[<[][]>((
(<[{{[{([<<<(((){})([][]))>([[<>{}])[<{}()>{<>{}}])>>{{{{<[]{}>[()()]}[(<>{}){<>{}}]}{([[]{
{(<[{({<<(<<<(<>())[{}[]]>>{([()()]({}{})){<[]()>[[]<>]}}>[[<[{}{}]{{}<>}>{[<>()][<><>]}]{<[<>][[]<>]>((<>{
{[<<(<<({(<<[{<>[]}]{[{}{}]<[]()>}>(((())<<><>>)((<>{})[{}[]]))>[<({<><>}[[]{}])[<()[]>{()()}]>{{({}[])({}()
<<<(<((([<{[{{{}<>}{{}[]}}[(<>)<<>[]>]]<[([])]<{()()}{<>{}}>>}><{<[[[]<>]<{}<>>]>[(({}[])<[]<>
{<(([[{{[({(([[]{}]<{}()>)<([]())[[][]}>)<<<<>>{()[]}>[<<>()>]>})<<[({[]<>}[[]<>])<<{}()>({})>]{<<()[]>(()[
([<([{<[<{<([<()>({}[])](<<>{}>{{}{}}))<<({}{}){{}()}>[([]{})[[]()]]>>{{<[()<>]{()<>}>((<>())[{}<>])}<[(<
<([{({({<({[[(()[])[[][]]][(()){()[]}]](<{()<>}(()())><[[]()]([][])>)}{[{[<><>][{}{}]}<(<>[]){{}[]}>]
(({[<<[[{{<[{{[][]}(()[])}{<()<>>}]([<[]<>><{}<>>]{<{}()>[<><>]})><{{<<>{}>[[]{}]}{<{}<>>[[]{})}}<<<{}<>>
<{{<(({{(<[<<[[][]]{[]()}>><<{()[]}{<>)>(({}{})(()()))>]{(<({})({}{})>([()()]<{}<>>)){([{}[]]([]{}))[<[]
{({[<<[[<[<(<{<>{}}{{}()]>([{}[]][()[]])){{[()[]]{<><>}}({<>()}[<>()])}><<{[()<>]<[]>}<({}[]
<{{<<{<{<([(([<>()])<({}())<{}[]>>)[[(()())[()()]]{{()()}<{}()>}]])<[([<{}{}><[][]>])[[<[]<>>{[]<>}
<{<([[<{[{([[[[][]]<[]<>>][({}()){()()}]]<(([]())[<>[]]){[()<>]}>)[[<<{}<>>([]{})>[(()<>)[[]()]]]]}((((<<>>
[[{[<<([[({{<<{}<>>{<><>}>[<(){}>([]<>)]}<{<{}[]>{()[]}}((<>{})<()[]>}>}[<([[][]]([][]))({()()}<()
[{[[{(<({(<({({}<>){{}[]}}{<<>[]>{()[]}})<(({}())[[]{}])>><[<{{}[]}>{<[][]>[()]}]{((<>{})(<>
{{<{[[[(<({<(<[][]><{}<>>)[(<>{})<<><>>]>})>)]]]}{([[<<{[{<<()[]>({}{})>({{}()})}]<{[{()()}]<[[]]<()>>
[{{[<((<<(({{[[]()]([]())}{<[]{}>[{}{}]}}<({<>{}}{()[]})<{{}}{{}[]}>>)(<<<{}[])<[]()>>({[]
([[[<(<([{(({{{}[]}[{}]}[[()()][{}{}]]}({(<>{})({}())}({()()}([]<>)))){{({()<>}(<>[]))[(()())<[][]>
{([<<{<(<((({({}[])({}[])}([<><>]([]())))<<<[]{}><<><>>>({{}[]}{()[]})>}(<[({}[]){<>[]}](<[][]>{{
{{(<{<([[<[[(((){})<{}[]>)[[[]<>][<>()]]]{((<>[])(<>())){<<>>([]{})}}]<[([[][]][{}])]>><(({{<>()}}[<[][]>])
{[[{<<<{{{[[(<(){}>{[]{}})]]}({<[[{}()][{}{}]]{({}[])[{}<>]}>{{{[]<>}[<>[]]}<{[][]}(<>[])>}})}{[<{[([][]){<
<[<{<[{<({(<<([][])<()[]>><[<>()]{{}()}>)<([()<>]<<>{}>)(({}<>)[()<>])>)})>}][(<<<[[({{}()}{{}[
<{{(<<{[{<{{{{[]<>}{()()}}{(<>()){()[]}}}[{(<>[])}(({}[])[()[]])]}<<[{<>()}]<{<>()}<{}()>>>{((<
{[<[{{[[<[{<<[[][]]<{}[]>>><<<()[]>({}[])>>}([[[[][]]]((<>())<<>()>)](<[{}()]<[][]>>({<>[]}{[]()}))>]{{<[{{}
<([[{[{<<(<{<[{}[]]{(){}}>(<{}<>>{<>()})}{(<(){}>{[]))((()<>)[{}[]])}><(<<(){}><()>>){(<()<>>(()()))<({}())[
{<(<<{<[<<<[[<[]{}><[]()>]<{{}{}}{{}<>}>]>[[(<<><>>((){}))]({<()()><{}{}>}({<>()}))]>>]([(({<{()()}[
([{[([({[[<[{(<>[])<<>()>}[[{}[]]<[][]>]]><(<<()<>>({}<>)><(()[])(()())>)({[[]{}]{<>()}}{[[]
[(({([{[<<[{{((){})({}())}}]{{{<()<>>[[]()]}((<>[])(<>()))}[[[<><>]([]())]({()[]}{()[]})]}>>({[[<<
<{{(([[[<(<(([[]()]<[]{}>))[<[{}{}](()())>[[()<>](()())]]>{<{<()<>>}(<{}<>>[[]()])>})>[({<
[<{([{{<<{{(<([]{})[<>{}]>[<()<>><()[]>])({(()<>)<<>[]>)(([]{})([]<>)))}}>[{[({({}())[(){}]}<(
<([<<[<(<<<<({()[]}<{}<>>)[[()[]][[]()]]><({{}{}}){[[][]]}>>{[((()[])[[][]]>{{()()}{()<>}}]<{<
<((<{<{<{<<[[<<>()>{<>}]{({}[])<<><>>}]([{()<>}{[][]}]([[]<>](<>())))>[<<[[]<>]<()()>>[{()()}<(){
<<{[{[{[<{{<<[<>()]<[]<>>>[[()()][{}{}]]>([{{}[]}<()<>>])}[((([]{})[[]<>])<<{}{}>{<>[]}))]}><[{(
{{{{<<[{<{(({<{}()><[]<>>})[{<[]{}><()()>}{<<>[]>[[][]]}))<{<[<>[]][[]{}]>{[(){}][[]()]}}{{
<<{([({{[{{<[<[][]>{[]<>}][<[]()>]>{{[{}][()[]]}({{}[]}[()[]])}}{[[<<>{}>](<()()>)][<[[]{}]<{}{}>>
[{{<{([[<{(({<[]{}><[]()>}<<()<>><<>()>>)<{(<>()}[{}<>]}>){(<{<>{}}({}[])><{()<>}>)}}[({(<[]()>({}<>))<[[]
{{{({({<{<{[[{[]{}}{[]()}]<{{}()}<{}[]>>]({<[]<>>[[]()]}<[<>[]}<{}<>>>)}{<<(()[])<()[]>>[(<>[])<()[]>]>(<[[](
<{[(([[[([[<[[{}()]([]<>)][(()[])[<><>]]>(([<>{}]({}()))<{{}}[[][]]>)]({{<{}[]><[]()>}({[]{})[[
{(<({({(<(<(([<>()][{}<>])<{()<>}<{}()>>)[[[()[]]<[]{}>][[()<>]<[]{}>]]>{<<<[]><[]()>><(<><>)<[]{}>>>})(([
<{<(([(<<<<<{(()<>)}{<()()>(<>[])}>>>>>){{(<<[[{<>[]}(<><>)]<{[]{}}>]>>)[([{[[<><>]<()()>]{(()[])<<><>>}
({{[(<([({((([()[]]{{}{}})[(<>{})([][])])){{({<><>}[()()]){<{}[]>[<><>]}}}}{(<[<<>[]>]>><<[{()}<()()>]
([{[[([{<[({{({}[]><[][]>}}((<()()>[<>[]])<({}())({}())>))]<[[[(<>{}){[]}]{{[][]}{()[]}}]]<{<<{}<>><<
({{<[[({{((<[{()<>}[{}[]]]([[]()](()[]))>{[{()[]}{{}[]}][{{}{}}{[]{}}]})({{[{}](<><>)}[([]()
[<<{[{({{[[{{<[]{}>[<>[]]}<({}[])[()[]]>>{[[<>()]{{}[]}][{[]{}}{[]()}]}][<<([]()){[]<>}>((<>){{}()})>[{{{}(
(<{[{<{[[[<[<{{}<>}<()>>{[<><>][()()]}][<[<>()]{{}{}}>([[]())[[]<>])]>]{[(<[()()]{<><>}>{[{}[]]<
<{[[[{(({{<({(()[])(<>{})}(<[][]>[<>]))({([]<>)<<>[]>}<[<><>][()()]>)>[<[[<><>][()()]](<()>[()<>]
[<[([[<<[{((<[<>{}][{}[]]><(<>{}){[]<>}>))}][{{<<<[][]><{}<>>>><({()[]}<()[]>)>}<([<(){}>({}())]<[{}][()]>)[
[([({{[[{{[[{{{}{}}<[]<>>}]]<{{{{}{}}<<>()>}((()())({}[]))}[[<(){}>(<>{})][[<>{}]{{}<>}]]>
<<[{<<([[({([[[][]]{{}()}])[[{{}[]}<{}()>]{[(){}]{<>[]}}]}([{{[][]}>]<{{()[]}<()[]>}<(()<>)
[[[{(<[[{(({<({}())>{{<>{}}[{}{}]]}<{{()()}[{}<>]}[<{}<>>(<><>)]>))<<<{<<>[]>}{[{}()][{}{}]}>[<[(){}][{}{}
{<([{[[([{[{(<()()><<>[]>)(({}{})[{}<>])}[<<()[]>[()<>]>{({}<>){()()}}]]<<{(<>[]){()()}}<{{}[]}(<><>)>>((
(({{<(<({[[{({{}[]}([][]))[{[]<>}<<>[]>]}[<{[]{}}([])>]]{{([<>[]]({}()))(<()<>>{[]{}})}}][{<<{<>()
{{[<[<(([<{[([()()][[]<>])[<()<>>{()[]}]]}>[{({{()()}([][])}({()}(()<>)))[[({}())]{{<>()}[<>]}]}]]{<{({({
{{([([({[<((<{<><>}>{(<>[])})([({}{}){<>()}]))<[{<{}{}>{<>[]}}]<(<(){}>{()<>}){<<><>>}>>>[{[
[<{<[(<{{[((<[<><>]{(){}}>(([]<>)[()()]))(<{{}()}[{}[]]>{<<><>>{()<>}}))({[<()()>{<><>}]<{[]<
<((([(<[{<<[<<<>()>({})>][((()[]))<{{}()><<><>>>]>>({[[[<>{}][<><>]]({{}()}<{}{}>)]}((<<[]>
[[{({[({[[[[<[<>()]{<>{}}>]{([<>{}](()<>))[[{}<>]({}[])]}]{{{(<>{})({}[]]}}[{[()<>]{()()}}]}]]<<{[((<>())<()<
{<{{{([(<([<[{<>()}{<>{}}]<([]{})<[][]>>>([<(){}>[[][]]]{<()<>><<>[]>})]<<<[()()]>>[([()()]
[([[(({[[{{<{(<>{})<(){}>}[({}{})[<><>]]>({<<>{}>[<>{}]})}}[[<{<()><{}{}>}{{<><>}}>([[()()]{{
{{[({({([([<({()}([]()))>[[(<>[]){<><>}][{[]{}]<{}>]]]{{[({}{}){<><>}][[[]<>][<>[]]]}((([]<
{{<<[<<(({[[{{{}()}({}{})}<{()[]}{()()}>][{{<>{}}[()<>]}([{}[]]{{}[]})]]<[{{[]<>}{<>{}}}{[<>[]]<[][]>}]
[{<({({<{{({{{<>{}}<{}()>}{(<>())[<>{}]}}[(<<>{}>[{}])])((<<<><>><{}()>>(<<><>>([])))(<([]<>)>{{
{[<[((<{{[{{<({}{})>}<((<>)<[]<>>)[[<>()]{{}}]>}]}}>))]({[{{([[<<<{}[]>><<<>()><<>[]>>>[{{(){}}}<[[]{}]({}
<<<[<({[(<(<<(()<>)<{}{}>>{([]<>){<>{}}}>{{<{}<>>(<>{})}<[()<>]>})<{[({}())[<>[]]]({<>()}<<>{}>)><{
({<<[{<<[{{<([(){}]<<>()>)<<<>()>[[]()]>>(<{<>()}([]())>{[[]<>](<>{})})}}]]{<(<<[<<><>>((){})]{
<([{{[{<<[[{{[{}[]][()]}<[{}()][[][]]>}}[<{[<>[]]{{}()}}>{(<()()><[][]>)({()<>})}]]<[<[<{}<>>([]<>)
([<<[[([(<<[({()<>})<{[]()}{()}>]({{()<>}})>{[([<>()]([]()))[{[]{}}]]}>{{{(<[]()><[]>)<{{}{}}[{
([[{[[{<{[{<({()()}[<>{}])<<{}{}><<>()>>><[[<>{}](<>()]]<<[][]>{<>{}}>>}][<{(<<>()>[()[]])<{<>{}}
<{<<{<((([{[<(())<{}[]>>]<(<{}()><<>{}>)<<<>{}>>>}<{{<<>()>{{}()}}<<(){}>>}[[{[]()}({}())]((<>
([[([(<[<<{[<[()<>][[]()]>[[[]<>]<()()>]][[(<><>)]<<<>>(<>[])>]}><{([(<><>)]{[()<>}})}>><<[[(<
{{(<<({<([([{{[]()}}([<>{}]{{}()})])])[[[[[[<>{}>({}())]{{[]{}}({}())}]]([{{<>}(()<>)}[{<>()}<[][]>]])](<[[[
((({{<[<<{{{<<[]()>[<>[]]>[({}[])([]{})]}<<[[]{}]<()<>>><({}())(())>>}[<<[(){}]<[]()>>[{{}<>}
[<([<{[([[[(<[<>{}]({}{})>([()[]]({})))([{()()}{()[]}]<[<><>]{()()}>)]({({(){}}{<><>})<[<>()]{{}()
<(({(<[[{[{[((<>())[{}])[[<>]{<>()}]](<{[][]}{<>()}>([<>{}>{[]<>}))}[[({<>{}}{<>()})((()[])<<>
<{{{{<{[[<[({{<>[]}(()<>)})<(<<>{}>[(){}])[{<>{}}{<>{}}]>]({[{<>()}<()<>>]{<[]()><{}()>}}([
