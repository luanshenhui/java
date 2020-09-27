import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

// ページ表示用セルのレイアウト設定
const Cell = styled.td`
  border: 1px solid #ccc;
  height: 25px;
  text-align: center;
  width: 25px;
`;

// 現在ページ表示用セルのレイアウト設定
const CurrentPageCell = Cell.extend`
  background-color: #eee;
  font-weight: bold;
`;

// ページネーション全体のレイアウト設定
const LayoutedTable = styled.table`
  margin-top: 10px;
  border-collapse: separate;
  border-spacing: 8px;
`;

// ページングナビゲータで表示するページ数
const pageCount = 10;

// pageCount値内で現在ページ番号を表示させる位置
const centerPos = 5;

const Pagination = ({ onSelect, totalCount, startPos, rowsPerPage }) => {
  // 総ページ数・現在ページ番号を求める
  const totalPages = Math.floor(totalCount / rowsPerPage) + (totalCount % rowsPerPage > 0 ? 1 : 0);
  const currentPage = ((startPos - 1) / rowsPerPage) + 1;

  // 開始ページ番号
  let startPage;

  // 現在ページ番号が全ページ中最後の(pageCount - centerPos + 1)ページ内に当てはまる場合
  if (currentPage > totalPages - ((pageCount - centerPos) + 1)) {
    // 最後の(pageCount)ページ分を表示させるよう開始ページを制御
    startPage = totalPages - pageCount > 0 ? (totalPages - pageCount) + 1 : 1;
  } else {
    // それ以外は現在ページ数がナビゲータの中心に位置するよう開始ページを制御
    startPage = currentPage > 4 ? currentPage - 4 : 1;
  }

  // 編集ページ番号及びURLに編集する開始検索位置の初期値を設定
  let wkPage = startPage;

  // 表示すべきページ番号の配列を作成
  const pages = [];
  while (wkPage <= totalPages && wkPage - startPage < pageCount) {
    pages.push(wkPage);
    wkPage += 1;
  }

  // ページ番号クリック時のイベント定義
  const handleClick = (event, page) => {
    // ブラウザデフォルト動作の抑止
    event.preventDefault();
    // propsで指定されたコールバック処理を呼ぶ
    onSelect(page);
  };

  return (
    <LayoutedTable>
      <tbody>
        <tr>
          {/* 前ページ移動リンクの編集 */}
          {startPage > 1 && (
            <td><a href="#" onClick={(event) => handleClick(event, currentPage - 1)}>&lt;&lt;prev</a></td>
          )}
          {/* ページ番号指定リンクの編集 */}
          {pages.map((page) => (
            page !== currentPage ? (
              <Cell key={page}><a href="#" onClick={(event) => handleClick(event, page)}>{page}</a></Cell>
            ) : (
              <CurrentPageCell key={page}>{page}</CurrentPageCell>
            )
          ))}
          {/* 次ページ移動リンクの編集 */}
          {pages[pages.length - 1] < totalPages && (
            <td><a href="#" onClick={(event) => handleClick(event, currentPage + 1)}>Next&gt;&gt;</a></td>
          )}
        </tr>
      </tbody>
    </LayoutedTable>
  );
};

// propTypesの定義
Pagination.propTypes = {
  onSelect: PropTypes.func.isRequired,
  totalCount: PropTypes.number.isRequired,
  startPos: PropTypes.number.isRequired,
  rowsPerPage: PropTypes.number.isRequired,
};

export default Pagination;
