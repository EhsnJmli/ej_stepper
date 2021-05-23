import 'package:flutter/material.dart';

const EdgeInsets _stepsMargin =
    EdgeInsets.symmetric(vertical: 16, horizontal: 8);

enum EJStepState {
  /// A step that is active and can be entered.
  enable,

  /// A step that is completed.
  complete,

  /// A step that is disabled and does not to react to taps.
  disable,

  /// A step that is currently having an error. e.g. the user has submitted wrong
  /// input.
  error,
}

class EJStep {
  const EJStep({
    this.title,
    this.subtitle,
    required this.content,
    this.state = EJStepState.enable,
    this.stepEnteredLeftWidget,
    this.leftWidget,
  });

  /// The title of the step that typically describes it.
  final Widget? title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  final Widget? subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  final Widget content;

  /// The state of the step which determines the styling of its components.
  ///
  /// defaults to [EJStepState.enable].
  final EJStepState state;

  /// The Widget which appears next to the [content] and below
  /// the [title] and [subtitle] when step is entered.
  final Widget? stepEnteredLeftWidget;

  /// The Widget which appears next to the [title] and [subtitle]
  /// when step is not entered.
  final Widget? leftWidget;
}

class EJStepper extends StatefulWidget {
  const EJStepper({
    Key? key,
    required this.steps,
    this.scrollPhysics,
    this.onStepTapped,
    this.onStepNext,
    this.onStepBack,
    this.onLastStepConfirmTap,
    this.currentStep,
    this.backButtonBuilder,
    this.nextButtonBuilder,
    this.leadingActiveColor,
    this.leadingInActiveColor,
    this.leadingDisableColor,
    this.leadingErrorColor,
    this.leadingCompleteColor,
    this.stepsMargin = _stepsMargin,
  })  : assert(currentStep == null ||
            (0 <= currentStep && currentStep < steps.length)),
        super(key: key);

  /// The steps of the stepper whose titles and subtitles always get shown.
  ///
  /// The length of [steps] must not change.
  final List<EJStep> steps;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics? scrollPhysics;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  ///
  /// Automatically it will change step to tapped step if state of step is not
  /// [EJStepState.disable].
  final ValueChanged<int>? onStepTapped;

  /// The callback called when the 'next' button is tapped, with current step index
  /// passed as an argument.
  ///
  /// If null, the steps keeps changing and step change isn't related to
  /// this function.
  final ValueChanged<int>? onStepNext;

  /// The callback called when the 'confirm' button is tapped.
  /// 'confirm' button only displayed in last step instead of 'next' button.
  final VoidCallback? onLastStepConfirmTap;

  /// The callback called when the 'back' button is tapped, with current step index
  /// passed as an argument.
  ///
  /// If null, the steps keeps changing and step changing isn't related to
  /// this function.
  final ValueChanged<int>? onStepBack;

  /// The index into [steps] of the current step whose content is displayed.
  final int? currentStep;

  /// The callback for creating custom back button.
  ///
  /// If null, the default back button which is the [child] will be used.
  ///
  /// This callback which takes in a child , an index which is the index of current step
  /// and a functions: [onBackPressed].
  /// It can be used to control the stepper.
  /// For example, keeping track of the [currentStep] within the callback can
  /// change the text of the back button depending on which step users are at.
  final Widget Function(VoidCallback onBackPressed, Widget child, int index)?
      backButtonBuilder;

  /// The callback for creating custom next button.
  ///
  /// If null, the default next button which is the [child] will be used.
  ///
  /// This callback which takes in a child , an index which is the index of current step
  /// and a functions: [onNextPressed].
  /// It can be used to control the stepper.
  /// For example, keeping track of the [currentStep] within the callback can
  /// change the text of the next button depending on which step users are at.
  final Widget Function(VoidCallback onNextPressed, Widget child, int index)?
      nextButtonBuilder;

  /// Color of leading when step's state is [EJStepState.enable] and stepper is
  /// in this step.
  final Color? leadingActiveColor;

  /// Color of leading when step's state is [EJStepState.enable] and stepper is not
  /// in this step.
  final Color? leadingInActiveColor;

  /// Color of leading when step's state is [EJStepState.disable].
  final Color? leadingDisableColor;

  /// Color of leading when step's state is [EJStepState.error].
  final Color? leadingErrorColor;

  /// Color of leading when step's state is [EJStepState.complete].
  final Color? leadingCompleteColor;

  /// Margin of each step.
  ///
  /// defaults to [_stepsMargin].
  final EdgeInsets stepsMargin;

  @override
  _EJStepperState createState() => _EJStepperState();
}

class _EJStepperState extends State<EJStepper> {
  int _currentStep = 0;

  @override
  void didUpdateWidget(covariant EJStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != null) {
      _currentStep = widget.currentStep!;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentStep != null) {
      _currentStep = widget.currentStep!;
    }
  }

  Color leadingColor(int index) {
    switch (widget.steps[index].state) {
      case EJStepState.enable:
        return index == _currentStep
            ? widget.leadingActiveColor ?? Colors.blue
            : widget.leadingInActiveColor ?? Colors.blue;
      case EJStepState.complete:
        return widget.leadingCompleteColor ?? Colors.green;
      case EJStepState.disable:
        return widget.leadingDisableColor ?? Colors.grey;
      case EJStepState.error:
        return widget.leadingErrorColor ?? Colors.red;
      default:
        return Colors.blue;
    }
  }

  bool _isCurrent(int index) => index == _currentStep;

  void _changeStep(int index) {
    setState(() {
      _currentStep = index;
    });
  }

  void _onBack(int index) {
    if (widget.steps[index - 1].state != EJStepState.disable) {
      _changeStep(index - 1);
      if (widget.onStepBack != null) {
        widget.onStepBack!(index);
      }
    }
  }

  void _onNext(int index) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (index == widget.steps.length - 1) {
      if (widget.onLastStepConfirmTap != null) {
        widget.onLastStepConfirmTap!();
      }
    } else {
      if (widget.steps[index + 1].state != EJStepState.disable) {
        _changeStep(index + 1);
        if (widget.onStepNext != null) {
          widget.onStepNext!(index);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          physics: widget.scrollPhysics,
          shrinkWrap: true,
          children: List.generate(
            widget.steps.length,
            _buildStep,
          ),
        ),
      );

  Widget _buildStep(int index) => InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (index != _currentStep) {
            if (widget.steps[index].state != EJStepState.disable) {
              _changeStep(index);
            }
          }
          if (widget.onStepTapped != null) {
            widget.onStepTapped!(index);
          }
        },
        child: Container(
          margin: widget.stepsMargin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
              )
            ],
          ),
          constraints: BoxConstraints(minHeight: 70),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        height: double.infinity,
                        color: leadingColor(index),
                        width: 15,
                      ),
                      PositionedDirectional(
                        start: -7.5,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.only(
                              bottomEnd: Radius.circular(100),
                              topEnd: Radius.circular(100),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: AnimatedCrossFade(
                      firstChild: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: _buildTitle(index),
                      ),
                      secondChild: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildTitle(index),
                            SizedBox(height: 8),
                            widget.steps[index].content,
                            SizedBox(),
                          ],
                        ),
                      ),
                      firstCurve:
                          const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
                      secondCurve:
                          const Interval(0.4, 1, curve: Curves.fastOutSlowIn),
                      sizeCurve: Curves.fastOutSlowIn,
                      crossFadeState: _isCurrent(index)
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: kThemeAnimationDuration,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_isCurrent(index) && index != 0)
                        _buildBackButton(index)
                      else
                        SizedBox.shrink(),
                      if (_buildLeftChild(index) != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 16,
                            bottom: 16,
                            top: 16,
                          ),
                          child: _buildLeftChild(index),
                        )
                      else
                        SizedBox.shrink(),
                      if (_isCurrent(index))
                        _buildNextButton(index)
                      else
                        SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildTitle(int index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.steps[index].title != null)
            widget.steps[index].title!
          else
            SizedBox(),
          if (widget.steps[index].subtitle != null)
            widget.steps[index].subtitle!,
        ],
      );

  Widget? _buildLeftChild(int index) => _isCurrent(index)
      ? widget.steps[index].stepEnteredLeftWidget
      : widget.steps[index].leftWidget;

  Widget _buildNextButton(int index) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(16),
        ),
      ),
      constraints: BoxConstraints(minWidth: 80),
      child: Text(
        index == widget.steps.length - 1
            ? MaterialLocalizations.of(context).okButtonLabel
            : MaterialLocalizations.of(context).continueButtonLabel,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white),
      ),
    );
    return widget.nextButtonBuilder != null
        ? widget.nextButtonBuilder!(() => _onNext(index), child, index)
        : GestureDetector(onTap: () => _onNext(index), child: child);
  }

  Widget _buildBackButton(int index) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(16),
        ),
      ),
      constraints: BoxConstraints(minWidth: 80),
      child: Text(
        MaterialLocalizations.of(context).backButtonTooltip,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white),
      ),
    );
    return widget.backButtonBuilder != null
        ? widget.backButtonBuilder!(() => _onBack(index), child, index)
        : GestureDetector(onTap: () => _onBack(index), child: child);
  }
}
