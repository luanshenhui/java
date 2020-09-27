import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import GuideBase from '../../../components/common/GuideBase';
import CtrSelectCourseGuide from './CtrSelectCourseGuide';
import CtrPeriodGuide from './CtrPeriodGuide';
import CtrDemandGuide from './CtrDemandGuide';
import { closeCtrCreateWizardGuide } from '../../../modules/preference/contractModule';

class CtrCreateWizard extends React.Component {
  constructor(props) {
    super(props);
    this.nextPage = this.nextPage.bind(this);
    this.previousPage = this.previousPage.bind(this);
    this.state = {
      page: 1,
      curPage: 1,
    };
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible } = this.props;
    if (visible && nextProps.visible !== visible) {
      this.setState({
        page: 1,
        curPage: 1,
      });
    }
  }
  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  nextPage() {
    this.setState({
      page: this.state.page + 1,
      curPage: this.state.page,
    });
  }

  previousPage() {
    this.setState({
      page: this.state.page - 1,
      curPage: this.state.page,
    });
  }

  render() {
    const { match, onSubmit } = this.props;
    const { page } = this.state;

    const guideTitle = () => {
      switch (page) {
        case 1:
          return '契約コースの選択';
        case 2:
          return '契約期間の指定';
        case 3:
          return '負担元の設定';
        default:
          return '';
      }
    };

    return (
      <GuideBase {...this.props} title={guideTitle()} usePagination={false}>
        {page === 1 && (
          <CtrSelectCourseGuide
            params={match.params}
            onNext={this.nextPage}
            curPage={this.state.curPage}
          />
        )}
        {page === 2 && (
          <CtrPeriodGuide
            params={match.params}
            onBack={this.previousPage}
            onNext={this.nextPage}
            newmode
          />
        )}
        {page === 3 && (
          <CtrDemandGuide
            params={match.params}
            onBack={this.previousPage}
            onSubmit={onSubmit}
            newmode
          />
        )}
      </GuideBase>
    );
  }
}

CtrCreateWizard.propTypes = {
  visible: PropTypes.bool.isRequired,
  match: PropTypes.shape().isRequired,
  reset: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  visible: state.app.preference.contract.ctrCreateWizard.visible,
});

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeCtrCreateWizardGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrCreateWizard);
