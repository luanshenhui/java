import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

// 検索条件・件数情報の編集
class DailyListEditCountTitle extends React.Component {
  // 受診日条件の編集
  getDispDate = (dtmStrDate, dtmEndDate) => {
    // 受診日
    let strDispDate = '';
    if (dtmStrDate === '' && dtmEndDate === '') {
      // 双方とも未指定の場合は編集しない
    } else if (dtmStrDate === '' || dtmEndDate === '') {
      strDispDate = dtmStrDate === '' ? moment(dtmEndDate, 'YYYYMMDD').format('YYYY年M月D日') : moment(dtmStrDate, 'YYYYMMDD').format('YYYY年M月D日');
      // 一方が未指定の場合はもう一方の値のみ編集する
    } else if (dtmStrDate === dtmEndDate) {
      // 双方の値が同値ならば一方の値のみ編集する
      strDispDate = moment(dtmStrDate, 'YYYYMMDD').format('YYYY年M月D日');
    } else {
      // 双方の値が異なれば時は期間形式で編集
      strDispDate = `${moment(dtmStrDate, 'YYYYMMDD').format('YYYY年M月D日')}～${moment(dtmEndDate, 'YYYYMMDD').format('YYYY年M月D日')}`;
    }
    return strDispDate;
  }

  render() {
    const { params, totalcount } = this.props;

    // 受診日条件の編集
    const strDispDate = this.getDispDate(params.strDate, params.endDate);

    if (params.isSearching) {
      return (
        <div style={{ fontSize: `${params.print === 0 ? 12 : 9}px` }}>
          {(params.key !== '' || strDispDate !== '') && <div style={{ float: 'left' }}>検索条件</div>}
          {/* 検索キーの編集  */}
          {params.key !== '' && <div style={{ float: 'left' }}>「<span style={{ color: '#ff6600', fontWeight: 'bolder' }}>{params.key}</span>」</div>}
          {/* 受診日条件の編集  */}
          {strDispDate !== '' && <div style={{ float: 'left' }}>「<span style={{ color: '#ff6600', fontWeight: 'bolder' }}>{strDispDate}</span>」</div>}
          {/* 受診日条件の編集  */}
          {(params.key !== '' || strDispDate !== '') && <div style={{ float: 'left' }}>の受診情報を検索しています…</div>}
          <div style={{ clear: 'left' }} />
        </div>
      );
    }

    return (
      <div style={{ fontSize: `${params.print === 0 ? 12 : 9}px` }}>
        {/* 検索キーの編集  */}
        {params.key !== '' && <div style={{ float: 'left' }}>「<span style={{ color: '#ff6600', fontWeight: 'bolder' }}>{params.key}</span>」</div>}
        {/* 受診日条件の編集  */}
        {strDispDate !== '' && <div style={{ float: 'left' }}>「<span style={{ color: '#ff6600', fontWeight: 'bolder' }}>{strDispDate}</span>」</div>}
        {/* 受診日条件の編集  */}
        {(params.key !== '' || strDispDate !== '') && <div style={{ float: 'left' }}>の受診者一覧を表示しています。検索結果は <span style={{ color: '#ff6600', fontWeight: 'bolder' }}>{totalcount}</span>件です。</div>}
        <div style={{ clear: 'left' }} />
      </div>
    );
  }
}

// propTypesの定義
DailyListEditCountTitle.propTypes = {
  totalcount: PropTypes.number.isRequired,
  params: PropTypes.shape().isRequired,
};

export default DailyListEditCountTitle;
