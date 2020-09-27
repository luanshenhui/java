import React from 'react';
import PropTypes from 'prop-types';
import qs from 'qs';

class DailyListEditTitle extends React.Component {
  getThStyles = (prtField, sortKey) => {
    let style;
    if (prtField === sortKey) {
      style = { backgroundColor: '#CCCCFF' }; // 選択色
    } else {
      style = { backgroundColor: '#CCCCCC' }; // 陰影用
    }
    return style;
  }

  // 日クリック時の処理
  handleTitleClick(prtField, sortKey, sortType) {
    const { history, params } = this.props;
    let sort;
    if (prtField === sortKey) {
      if (sortType === 0) {
        sort = 1;
      } else {
        sort = 0;
      }
    } else {
      sort = 0;
    }

    history.push({
      pathname: '/reserve/frontdoor/dailylist',
      search: qs.stringify({ ...params, sortKey: prtField, sortType: sort, isSearchButtonClick: '0' }),
    });
  }

  render() {
    const { params } = this.props;
    const { arrPrtField, print, sortKey, sortType } = params;

    // アンカーの要否
    let blnAnchor;

    // タイトル
    const strTitle = ['',
      '時間枠', '当日ＩＤ', '管理番号', 'コース', '氏名',
      'カナ氏名', '性', '生年月日', '年齢', '団体',
      '予約番号', '受診日', '予約日', '受診セット', '受付日',
      '個人名称', '個人ＩＤ', '受診項目', '部門送信', '日数',
      '従業員番号', '受診時健保記号', '受診時健保番号', '事業部', '室部',
      '所属', '受診日確定', 'ＯＣＲ用受診日', '検体番号', '問診票出力日',
      '胃カメラ受診日', 'サブコース', '健保記号', '健保番号', '結果入力状態',
      '予約状況', '確認はがき出力日', '一式書式出力日', '予約群', 'お連れ様'];
    const tdHtml = [];
    for (let i = 0; i < arrPrtField.length; i += 1) {
      // アンカー表示の要否を決定する
      blnAnchor = false;

      // 印刷用表示モードの場合はアンカー不用
      if (print !== 1) {
        // 追加検査・受付日・受診項目・部門送信・日数・検体番号・サブコース、その他未使用項目の場合はアンカー不用
        if ([1, 3, 14, 15, 18, 19, 20, 21, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 40].indexOf(arrPrtField[i]) < 0) {
          blnAnchor = true;
        }
      }

      // アンカーが必要な場合
      if (blnAnchor) {
        tdHtml.push((
          <th
            key={arrPrtField[i]}
            style={this.getThStyles(arrPrtField[i], sortKey)}
            nowrap="true"
          >
            <a
              role="presentation"
              style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}
              onClick={() => (this.handleTitleClick(arrPrtField[i], sortKey, sortType))}
            >
              {strTitle[arrPrtField[i]]}
            </a>
          </th>));
      } else {
        // アンカーが不用な場合
        tdHtml.push(<th key={arrPrtField[i]} nowrap="true">{strTitle[arrPrtField[i]]}</th>);
      }
    }

    return (
      <tr bgcolor="#cccccc">
        {tdHtml}
        {print === 0 && <th align="center" nowrap="true">操作</th>}
      </tr>
    );
  }
}

// プロパティの型を定義する
DailyListEditTitle.propTypes = {
  history: PropTypes.shape().isRequired,
  params: PropTypes.shape().isRequired,
};

export default DailyListEditTitle;
