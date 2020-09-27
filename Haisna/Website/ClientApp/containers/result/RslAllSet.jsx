import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { connect } from 'react-redux';
import { getFormValues } from 'redux-form';
import PageLayout from '../../layouts/PageLayout';
import RslAllSetStep1 from './RslAllSetStep1';
import RslAllSetStep2 from './RslAllSetStep2';
import RslAllSetStep3 from './RslAllSetStep3';
import RslAllSetStep4 from './RslAllSetStep4';
import RslAllSetStep5 from './RslAllSetStep5';
import { getConsultStepList } from '../../modules/reserve/consultModule';

const formName = 'rslAllSetForm';
class RslAllSet extends React.Component {
  constructor(props) {
    super(props);
    this.nextPage = this.nextPage.bind(this);
    this.previousPage = this.previousPage.bind(this);
    this.lastPage = this.lastPage.bind(this);
    this.overPage = this.overPage.bind(this);
    this.previousPage = this.previousPage.bind(this);
    this.state = {
      page: 1,
      curPage: 1,
    };
  }


  // propが更新される際に呼ばれる処理
  componentWillUnmount() {
    const { onLoad } = this.props;
    onLoad();
  }

  nextPage() {
    this.setState({
      page: this.state.page + 1,
      curPage: this.state.page,
    });
  }

  lastPage() {
    this.setState({
      page: 4,
    });
  }

  overPage() {
    this.setState({
      page: 5,
    });
  }

  previousPage() {
    this.setState({
      page: this.state.page - 1,
      curPage: this.state.page,
    });
  }

  render() {
    const { match } = this.props;
    const { page } = this.state;
    return (
      <PageLayout title="検査結果を一括して入力">
        {page === 1 && (
          <RslAllSetStep1
            params={match.params}
            onNext={this.nextPage}
            curPage={this.state.curPage}
          />
        )}
        {page === 2 && (
          <RslAllSetStep2
            params={match.params}
            onNext={this.nextPage}
            onLast={this.lastPage}
            curPage={this.state.curPage}
            onBack={this.previousPage}
          />
        )}
        {page === 3 && (
          <RslAllSetStep3
            params={match.params}
            onNext={this.nextPage}
            onLast={this.lastPage}
            curPage={this.state.curPage}
            onBack={this.previousPage}
          />
        )}
        {page === 4 && (
          <RslAllSetStep4
            params={match.params}
            onNext={this.nextPage}
            onOver={this.overPage}
            curPage={this.state.curPage}
          />
        )}
        {page === 5 && (
          <RslAllSetStep5
            params={match.params}
          />
        )}
      </PageLayout>
    );
  }
}

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      cslDate: moment().format('YYYY/MM/DD'),
      cscd: '',
      grpcd: 'G010',
      dayIdF: '',
      dayIdT: '',
    },
  };
};

RslAllSet.propTypes = {
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({

  // 画面を初期化
  onLoad: () => {
    dispatch(getConsultStepList());
  },

});

export default connect(mapStateToProps, mapDispatchToProps)(RslAllSet);
