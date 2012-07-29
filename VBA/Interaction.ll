; -*- indent-tabs-mode: nil -*-
; Copyright © 2012 Iain Nicol

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU Affero General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU Affero General Public License for more details.
;
; You should have received a copy of the GNU Affero General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

declare dllimport x86_stdcallcc i32 @MessageBoxW(i8*, i16*, i16*, i32)

; "Project1"
@project1 = private constant [9 x i16] [i16 80, i16 114, i16 111, i16 106,
                                        i16 101, i16 99, i16 116, i16 49,
                                        i16 0]

; TODO: implement this function against the correct prototype.
; Currently we implement only the first parameter, which we take as a
; string.  Also, the return type is wrong.
define x86_stdcallcc void @MsgBox(i16* %s)
{
  %r = call x86_stdcallcc i32 @MessageBoxW(
           i8* null,
           i16* %s,
           i16* getelementptr inbounds ([9 x i16]* @project1,
                                        i64 0,
                                        i64 0),
           i32 0)
  ret void
}
