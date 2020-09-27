import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import GuideBase from '../../components/common/GuideBase';
import EditWelComeInfoGuide from './EditWelComeInfoGuide';
import ReceiptFrontDoorGuide from './ReceiptFrontDoor';
import ReceiptMainGuide from './ReceiptMainGuide';

import { closeWelComeInfoMenuGuide } from '../../modules/reserve/consultModule';

class WelComeInfoMenuGuide extends React.Component {
  render() {
    const { pagestats, mode } = this.props;
    const guideTitle = () => {
      switch (pagestats) {
        case 1:
          return '受付入力';
        case 2:
          return '来院確認';
        case 3:
          if (mode != null) {
            if (mode === 1) {
              return '当日IDの設定';
            } else if (mode === 2) {
              return '来院の設定';
            } else if (mode === 3) {
              return 'OCR番号の設定';
            } else if (mode === 4) {
              return 'ロッカーキーの設定';
            }
          }
          return '';
        default:
          return '';
      }
    };

    return (
      <GuideBase {...this.props} title={guideTitle()} usePagination={false}>
        {pagestats === 1 && (
          <ReceiptFrontDoorGuide jumpsource="ReceiptMain" />
        )}
        {pagestats === 2 && (
          <ReceiptMainGuide />
        )}
        {pagestats === 3 && (
          <EditWelComeInfoGuide />
        )}
      </GuideBase>
    );
  }
}

WelComeInfoMenuGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  mode: PropTypes.number.isRequired,
  onClose: PropTypes.func.isRequired,
  pagestats: PropTypes.number.isRequired,
};

const mapStateToProps = (state) => ({
  visible: state.app.reserve.consult.welComeInfoMenuGuide.visible,
  pagestats: state.app.reserve.consult.welComeInfoMenuGuide.pagestats,
  mode: state.app.reserve.consult.welComeInfoMenuGuide.mode,
});

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeWelComeInfoMenuGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(WelComeInfoMenuGuide);
